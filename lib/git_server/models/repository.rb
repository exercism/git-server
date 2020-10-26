module GitServer
  class Repository
    extend Mandate::Memoize

    def initialize(repo_name, repo_url: nil)
      @repo_name = repo_name
      # TODO; Switch when we move back out of monorepo
      # @repo_url = repo_url || "https://github.com/exercism/#{repo_name}"
      @repo_url = repo_url || "https://github.com/exercism/v3"
    end

    def head_commit
      main_branch.target
    end

    def read_json_blob(commit, path)
      oid = find_blob_oid(commit, path)
      raw = read_blob(oid, "{}")
      JSON.parse(raw, symbolize_names: true)
    end

    def read_blob(oid, default = nil)
      blob = lookup(oid)
      blob.present? ? blob.text : default
    end

    %i[commit tree].each do |type|
      define_method "lookup_#{type}" do |oid|
        lookup(oid).tap do |object|
          raise 'wrong-type' if object.type != type
        end
      rescue Rugged::OdbError
        raise 'not-found'
      end
    end

    def find_blob_oid(commit, path)
      parts = path.split('/')
      target_filename = parts.pop
      dir = "#{parts.join('/')}/"

      commit.tree.walk_blobs do |obj_dir, obj|
        return obj[:oid] if obj[:name] == target_filename && obj_dir == dir
      end

      raise "No blob found: #{target_filename}"
    end

    def read_tree(commit, path)
      parts = path.split("/")
      dir_name = parts.pop
      root_path = parts.present? ? "#{parts.join('/')}/" : ""

      commit.tree.walk_trees do |obj_dir, obj|
        return lookup(obj[:oid]) if obj_dir == root_path && obj[:name] == dir_name
      end

      raise "No blob found: #{path}"
    end

    def lookup(*args)
      rugged_repo.lookup(*args)
    end

    private
    attr_reader :repo_name, :repo_url

    def main_branch
      rugged_repo.branches[MAIN_BRANCH_REF]
    end

    def repo_dir
      "#{repos_dir}/#{Digest::SHA1.hexdigest(repo_url)}-#{repo_name}"
    end

    memoize
    def repos_dir
      return "./test/tmp/git_repo_cache" if Exercism.config.test?

      "./tmp/git_repo_cache"
    end

    memoize
    def rugged_repo
      if File.directory?(repo_dir)
        Rugged::Repository.new(repo_dir).tap do |r|
          r.fetch('origin') if keep_up_to_date?
        rescue Rugged::NetworkError
          # Don't block development offline
        end
      else
        Rugged::Repository.clone_at(repo_url, repo_dir, bare: true)
      end
    rescue StandardError => e
      p "Failed to clone repo #{repo_url}"
      p e.message
      raise
    end

    # If we're in dev or test mode we want to just fetch
    # every time to get up to date. In production
    # we schedule this based of webhooks instead
    def keep_up_to_date?
      !!ENV["ALWAYS_FETCH_ORIGIN"]
    end

    MAIN_BRANCH_REF = "origin/master".freeze
    private_constant :MAIN_BRANCH_REF
  end
end
