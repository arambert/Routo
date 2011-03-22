module Routo

  class Number
    attr_accessor :number
    def initialize number
      @number = number
    end
    def send_sms msg
      Message.new(msg).send_sms(@number)
    end
  end

end