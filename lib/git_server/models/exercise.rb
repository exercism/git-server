module GitServer
  class Exercise
    extend Mandate::Memoize

    # TODO: repo_url can be removed once we're out of a monorepo
    def initialize(track_slug, exercise_slug, git_sha, repo_url: nil)
      @repo = Repository.new(track_slug, repo_url: repo_url)
      @track_slug = track_slug
      @exercise_slug = exercise_slug
      @git_sha = git_sha
    end

    def filepaths
      files.map { |defn| defn[:full] }
    end

    def read_file_blob(path)
      mapped = files.map { |f| [f[:full], f[:oid]] }.to_h
      mapped[path] ? repo.read_blob(mapped[path]) : nil
    end

    def version
      config[:version]
    end

    private
    attr_reader :repo, :track_slug, :exercise_slug, :git_sha

    memoize
    def files
      tree.walk(:preorder).map do |root, entry|
        next if entry[:type] == :tree

        entry[:full] = "#{root}#{entry[:name]}"
        entry
      end.compact
    end

    memoize
    def tree
      # TODO: When things are exploded back into repos, do this
      # repo.read_tree(commit, "exercises/concept/#{slug}")
      repo.read_tree(commit, "languages/#{track_slug}/exercises/concept/#{exercise_slug}")
    end

    memoize
    def config
      HashWithIndifferentAccess.new(
        JSON.parse(read_file_blob('.meta/config.json'))
      )
    end

    memoize
    def commit
      repo.lookup_commit(git_sha)
    end
  end
end
