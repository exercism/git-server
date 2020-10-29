module GitServer
  class RetrieveConceptData
    include Mandate
    def initialize(track_slug, concept_slug, git_sha = "HEAD", repo_url: nil)
      @concept = Concept.new(track_slug, concept_slug, git_sha, repo_url: repo_url)
    end

    def call
      {
        about: concept.about,
        links: concept.links
      }
    rescue StandardError
      {}
    end

    private
    attr_reader :concept
  end
end
