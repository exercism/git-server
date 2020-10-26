ENV['APP_ENV'] = 'test'

# This must happen above the env require below
if ENV['CAPTURE_CODE_COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails'
end

gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/mock'
require 'mocha/minitest'
require 'timecop'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'git_server'

ENV["ALWAYS_FETCH_ORIGIN"] = 'true'

module Minitest
  class Test
    def config
      GitServer::Configuration.instance
    end

    def git_repo_url(name)
      "file://#{File.expand_path("repos/#{name}", __dir__)}"
    end
  end
end
