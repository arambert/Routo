module Routo

  module Exception
    class Base < ::Exception
      def initialize message, body
        msg = "[number=#{message.recipients}] #{msg}"
        super(msg)
      end
    end
  end

end
Dir[File.expand_path('../exception/', __FILE__)+'/*.rb'].each {|file| require(file) }
