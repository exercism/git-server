ENV['APP_ENV'] ||= 'development'

require 'json'
require 'mandate'
require 'singleton'
require 'exercism-config'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

module GitServer
end
