require 'routo/exception'
require 'routo/number'
require 'routo/message'
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

  def self.config
    yield self
  end

  def self.send_sms msg, *numbers
    Message.new(msg).send_sms(*numbers)
  end
  
end