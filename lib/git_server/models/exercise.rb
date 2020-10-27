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

    memoize
    def code_files
      code_filepaths.each.with_object({}) do |filepath, hash|
        hash[filepath] = read_file_blob(filepath)
      end
    end

    memoize
    def code_filepaths
      filepaths.map do |filepath, _hash|
        next if filepath.match?(track.ignore_regexp)
        next if filepath.start_with?(".meta")

        filepath
      end.compact
    end

    def read_file_blob(path)
      mapped = file_entries.map { |f| [f[:full], f[:oid]] }.to_h
      mapped[path] ? repo.read_blob(mapped[path]) : nil
    end

    private
    attr_reader :repo, :track_slug, :exercise_slug, :git_sha

    def filepaths
      file_entries.map { |defn| defn[:full] }
    end

    # def version
    #   config[:version]
    # end

    memoize
    def file_entries
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

    memoize
    def track
      Track.new(track_slug, repo: repo)
    end
  end
end
