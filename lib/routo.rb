require 'routo/exception'
require 'routo/number'
require 'routo/message'
require 'pony'
module Routo
  mattr_accessor :username
  @@username = ""
  mattr_accessor :password
  @@password = ""
  mattr_accessor :http_api_url
  @@http_api_url = "http://smsc5.routotelecom.com/SMSsend"
  mattr_accessor :http_api_url_backup
  @@http_api_url_backup = "http://smsc56.routotelecom.com/SMSsend"
  mattr_accessor :ownnum
  mattr_accessor :type
  mattr_accessor :delivery
  @@delivery = 0

  # Email Options
  # config.email                 : recipient for the email notifications (default: nil)
  # config.email_options         : Hash with email config (smtp, sendmail, ...). We use the Pony gem to send mails, this hash will be send to Pony.options
  # config.seconds_between_mails : Minimum time (in seconds) between 2 mails with the same subject
  mattr_accessor :email
  mattr_accessor :email_options
  @@email_options = {}
  mattr_accessor :seconds_between_mails
  @@seconds_between_mails = 600
  
  mattr_accessor :no_credits_left
  @@no_credits_left = {:subject => 'Routo Messaging: no credits left', :body => 'You do not have any credit left on Routo messaging. You should buy some more credits in order to be able to send more SMS.'}
  mattr_accessor :no_credits_left_sent_at

  mattr_accessor :using_backup_url
  @@using_backup_url = {:subject => 'Routo Messaging: using backup url', :body => 'The primary Routo Messaging http API url was not responding correctly. We tried the backup API.'}
  mattr_accessor :using_backup_url_sent_at

  def self.config
    yield self
    Pony.options = @@email_options
  end

  def self.send_sms msg, *numbers
    Message.new(msg).send_sms(*numbers)
  end

  # not tested
  def self.balance
    balance = open("http://smsc5.routotelecom.com/balance.php?username=#{URI.encode(Routo.username)}=&password=#{URI.encode(Routo.password)}")
    balance.to_i
  end
  
end