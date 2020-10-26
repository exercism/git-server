module GitServer
  class Track
    def initialize(slug, repo_url:)
      @repo = Repository.new(slug, repo_url: repo_url)
      @slug = slug
    end

    def head_sha
      repo.head_commit.oid
    end

    def test_regexp
      pattern = config[:test_pattern]
      Regexp.new(pattern.presence || "[tT]est")
    end

    def ignore_regexp
      pattern = config[:ignore_pattern]
      Regexp.new(pattern.presence || "[iI]gnore")
    end

    def config(commit: repo.head_commit)
      repo.read_json_blob(commit, "languages/#{slug}/config.json")
    end

    private
    attr_reader :repo, :slug
  end
end
