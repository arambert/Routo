module Routo

  class Message

    attr_accessor :text
    attr_accessor :recipients

    def initialize text
      @text = text
      generate_mess_id
    end

    def send_sms *numbers
      options = numbers.last.is_a?(Hash) ? numbers.pop : {}
      @recipients = numbers.map{|n| Number.new(n)}
      begin
        parse_response(Net::HTTP.post_form(URI.parse(Routo.http_api_url), params(options)))
      rescue Routo::Exception::SystemError, Routo::Exception::Failed # trying with backup url if Routo returns an internal error
        begin # here a mail error should not prevent the sms to be send
          Pony.mail(:to => Routo.email, :subject => Routo.using_backup_url[:subject], :body => Routo.using_backup_url[:body]) if Routo.email && Routo.using_backup_url.present? && Routo.using_backup_url_sent_at.to_i<(Time.now.to_i-Routo.seconds_between_mails)
          Routo.using_backup_url_sent_at = Time.now
        ensure
          parse_response(Net::HTTP.post_form(URI.parse(Routo.http_api_url_backup), params(options)))
        end
      end
    end

    private

    def params options
      {:user => Routo.username,
       :pass => Routo.password,
       :number => @recipients.map(&:number).join(','),
       :ownnum => Routo.ownnum,
       :message => @text,
       :type => Routo.type,
       :delivery => Routo.delivery,
       :mess_id => @mess_id}.merge(options)
    end

    def generate_mess_id
      chars = ("A".."Z").to_a + ("0".."9").to_a
      @mess_id = Array.new(30){||chars[rand(chars.size)]}.join
    end

    def parse_response rep
      Rails.logger.debug "body: "+rep.body.inspect
      Rails.logger.debug "msg: "+rep.message.inspect
      case rep.body
        when /success/i           then return true
        when /error/i             then raise Routo::Exception::Error.new(self, rep.body)
        when /auth_failed/i       then raise Routo::Exception::AuthFailed.new(self, rep.body)
        when /wrong_number/i      then raise Routo::Exception::WrongNumber.new(self, rep.body)
        when /not_allowed/i       then raise Routo::Exception::NotAllowed.new(self, rep.body)
        when /too_many_numbers/i  then raise Routo::Exception::TooManyNumbers.new(self, rep.body)
        when /no_message/i        then raise Routo::Exception::NoMessage.new(self, rep.body)
        when /too_long/i          then raise Routo::Exception::TooLong.new(self, rep.body)
        when /wrong_type/i        then raise Routo::Exception::WrongType.new(self, rep.body)
        when /wrong_message/i     then raise Routo::Exception::WrongMessage.new(self, rep.body)
        when /wrong_format/i      then raise Routo::Exception::WrongFormat.new(self, rep.body)
        when /bad_operator/i      then raise Routo::Exception::BadOperator.new(self, rep.body)
        when /failed/i            then raise Routo::Exception::Failed.new(self, rep.body)
        when /sys_error/i         then raise Routo::Exception::SystemError.new(self, rep.body)
        when /no credits left/i   then raise Routo::Exception::NoCreditsLeft.new(self, rep.body)
        else raise Routo::Exception::Base.new(self, rep.body)
      end
    end

  end

end