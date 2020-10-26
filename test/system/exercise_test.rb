require_relative 'base'

module GitServer
  class ExerciseResponseTest < SystemBaseTestCase
    def test_response
      track_slug = "ruby"
      exercise_slug = "bob"
      git_sha = "123-foobar"

      data = { instructions: "Yippy" }

      RetrieveExerciseData.expects(:call).
        with(track_slug, exercise_slug, git_sha).
        returns(data)

      get "/exercises/#{track_slug}/#{exercise_slug}/#{git_sha}"
      assert_equal 200, last_response.status
      assert_equal({ exercise: data }.to_json, last_response.body)
    end
  end
end
