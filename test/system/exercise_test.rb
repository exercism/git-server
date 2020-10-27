require_relative 'base'

module GitServer
  class ExerciseResponseTest < SystemBaseTestCase
    def test_exercise_data
      GitServer::Repository.any_instance.stubs(repo_url: git_repo_url("v3-monorepo"))

      get "/exercises/csharp/datetime/data?git_sha=88bfc517efcabd63714ee3b1d853d9bf233f4f3b"
      assert_equal 200, last_response.status

      resp = JSON.parse(last_response.body)
      assert resp['exercise']['instructions'].start_with?("In this exercise you'll be")
    end

    def test_exercise_code_filepaths
      GitServer::Repository.any_instance.stubs(repo_url: git_repo_url("v3-monorepo"))

      get "/exercises/csharp/datetime/code_filepaths?git_sha=88bfc517efcabd63714ee3b1d853d9bf233f4f3b"
      assert_equal 200, last_response.status

      resp = JSON.parse(last_response.body)
      expected = [
        ".docs/hints.md",
        ".docs/instructions.md",
        ".docs/introduction.md",
        "README.md",
        "bob.rb",
        "bob_test.rb",
        "subdir/more_bob.rb"
      ]
      assert_equal expected, resp['filepaths']
    end

    def test_exercise_code_files
      GitServer::Repository.any_instance.stubs(repo_url: git_repo_url("v3-monorepo"))

      get "/exercises/csharp/datetime/code_files?git_sha=88bfc517efcabd63714ee3b1d853d9bf233f4f3b"
      assert_equal 200, last_response.status

      resp = JSON.parse(last_response.body)
      file = resp['files'][".docs/hints.md"]
      assert file.start_with?("## General")
    end

    def test_exercise_file
      GitServer::Repository.any_instance.stubs(repo_url: git_repo_url("v3-monorepo"))

      get "/exercises/csharp/datetime/file?git_sha=88bfc517efcabd63714ee3b1d853d9bf233f4f3b&filepath=.meta/config.json"
      assert_equal 200, last_response.status

      resp = JSON.parse(last_response.body)
      assert_equal "{\n  \"version\": \"15.8.12\"\n}\n", resp["content"]
    end
  end
end
