require_relative 'base'

module GitServer
  class ConceptResponseTest < SystemBaseTestCase
    def test_concept_data
      GitServer::Repository.any_instance.stubs(repo_url: git_repo_url("v3-monorepo"))

      get "/concepts/csharp/datetimes/data?git_sha=a9ce558b702ada6c5503888dc324668ac8aafc52"
      assert_equal 200, last_response.status

      resp = JSON.parse(last_response.body)
      assert resp['concept']['about'].start_with?("A `DateTime` in C# is an immutable object")

      assert_equal 3, resp['concept']['links'].count
      assert_equal "https://docs.microsoft.com/en-us/dotnet/api/system.datetime?view=netcore-3.1", resp['concept']['links'][0]["url"] # rubocop:disable Layout/LineLength
      assert_equal "DateTime class", resp['concept']['links'][0]["description"]
    end
  end
end
