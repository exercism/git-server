module GitServer
  class RetrieveExerciseData
    include Mandate
    def initialize(track_slug, exercise_slug, git_sha, repo_url: nil)
      @exercise = Exercise.new(track_slug, exercise_slug, git_sha, repo_url: repo_url)
    end

    def call
      {
        instructions: exercise.read_file_blob('.docs/instructions.md')
      }
    end

    private
    attr_reader :exercise
  end
end
