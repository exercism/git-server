require_relative 'base'

module GitServer
  class RuokTest < SystemBaseTestCase
    def test_200s
      get '/'
      assert_equal 200, last_response.status
      assert_equal({ ruok: :yes }.to_json, last_response.body)
    end
  end
end
