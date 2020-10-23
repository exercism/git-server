require 'test_helper'
require 'rack/test'

module GitServer
  class SystemBaseTestCase < Minitest::Test
    include Rack::Test::Methods

    def app
      Webserver
    end
  end
end
