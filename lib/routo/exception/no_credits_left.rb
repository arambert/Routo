module Routo
  module Exception
    class NoCreditsLeft < Base
      def initialize message, text
        super(message, text)
        Pony.mail(:to => Routo.email, :subject => Routo.no_credits_left[:subject], :body => Routo.no_credits_left[:body]) if Routo.email && Routo.no_credits_left.present? && Routo.no_credits_left_sent_at.to_i<(Time.now.to_i-Routo.seconds_between_mails)
        Routo.no_credits_left_sent_at = Time.now
      end
    end
  end
end
