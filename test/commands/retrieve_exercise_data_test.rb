require 'test_helper'

module GitServer
  class RetrieveExerciseDataTest < Minitest::Test
    def test_instructions
      data = RetrieveExerciseData.(
        :csharp,
        :datetime,
        "88bfc517efcabd63714ee3b1d853d9bf233f4f3b",
        repo_url: git_repo_url("v3-monorepo")
      )
      assert data[:instructions].start_with?("In this exercise you'll be")
    end
  end
end
