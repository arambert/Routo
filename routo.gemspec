version = "0.0.1"

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'routo'
  s.version = version
  s.summary = 'Sending sms with Routo Messaging.'
  s.description = 'Sending sms with Routo Messaging.'

  s.files = Dir['README.md', 'lib/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.required_ruby_version = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.author = 'Adrien Rambert'
  s.email = 'arambert@weboglobin.com'
  s.homepage = 'http://www.weboglobin.com'

end