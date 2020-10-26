require 'test_helper'

module GitServer
  class TrackTest < Minitest::Test
    def test_monorepo_test_regexp
      track = Track.new(:csharp, repo_url: git_repo_url("v3-monorepo"))
      assert_equal(/.+test[.]rb$/, track.test_regexp)
    end

    def test_monorepo_ignore_regexp
      track = Track.new(:csharp, repo_url: git_repo_url("v3-monorepo"))
      assert_equal(/[iI]gnore/, track.ignore_regexp)
    end

    def test_retrieves_test_regexp
      skip # TODO: Renable when not in monorepo
      track = Git::Track.new("track-with-exercises", :ruby)
      assert_equal(/test/, track.test_regexp)
    end

    def test_has_correct_default_test_regexp
      skip # TODO: Renable when not in monorepo
      track = Git::Track.new(TestHelpers.git_repo_url("track-naked"), :ruby)
      assert_equal(/[tT]est/, track.test_regexp)
    end

    def test_retrieves_ignore_regexp
      skip # TODO: Renable when not in monorepo
      track = Git::Track.new(TestHelpers.git_repo_url("track-with-exercises"), :ruby)
      assert_equal(/[iI]gno/, track.ignore_regexp)
    end

    def test_has_correct_default_ignore_regexp
      skip # TODO: Renable when not in monorepo
      track = Git::Track.new(TestHelpers.git_repo_url("track-naked"), :ruby)
      assert_equal(/[iI]gnore/, track.ignore_regexp)
    end
  end
end
