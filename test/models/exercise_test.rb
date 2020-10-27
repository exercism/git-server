require 'test_helper'

module GitServer
  class ExerciseTest < Minitest::Test
    def test_code_files
      exercise = Exercise.new(
        :csharp,
        :datetime,
        "88bfc517efcabd63714ee3b1d853d9bf233f4f3b",
        repo_url: git_repo_url("v3-monorepo")
      )

      expected_files = [
        ".docs/hints.md",
        ".docs/instructions.md",
        ".docs/introduction.md",
        # ".meta/config.json",
        "README.md",
        "bob.rb",
        "bob_test.rb",
        "subdir/more_bob.rb"
      ]
      assert_equal expected_files, exercise.code_files.keys
      assert exercise.code_files[".docs/hints.md"].start_with?("## General")
    end
  end
end
