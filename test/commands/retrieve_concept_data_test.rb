require 'test_helper'

module GitServer
  class RetrieveConceptDataTest < Minitest::Test
    def test_about
      data = RetrieveConceptData.(
        :csharp,
        :datetimes,
        "a9ce558b702ada6c5503888dc324668ac8aafc52",
        repo_url: git_repo_url("v3-monorepo")
      )
      assert data[:about].start_with?("A `DateTime` in C# is an immutable object")
    end

    def test_links
      data = RetrieveConceptData.(
        :csharp,
        :datetimes,
        "a9ce558b702ada6c5503888dc324668ac8aafc52",
        repo_url: git_repo_url("v3-monorepo")
      )

      assert_equal 3, data[:links].count
      assert_equal "https://docs.microsoft.com/en-us/dotnet/api/system.datetime?view=netcore-3.1", data[:links][0]["url"] # rubocop:disable Layout/LineLength
      assert_equal "DateTime class", data[:links][0]["description"]
    end
  end
end
