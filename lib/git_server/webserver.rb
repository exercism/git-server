$stdout.sync = true
$stderr.sync = true

require 'sinatra/base'
require 'sinatra/json'

module GitServer
  class Webserver < Sinatra::Base
    # Ping check for ELBs
    get '/' do
      json(ruok: :yes)
    end

    post '/pull' do
      Repository.new(nil).update!
      json(didwhatiwastold: true)
    end

    get '/exercises/:track_slug/:exercise_slug/data' do
      data = RetrieveExerciseData.(
        params[:track_slug],
        params[:exercise_slug],
        params[:git_sha]
      )
      json(exercise: data)
    end

    get '/exercises/:track_slug/:exercise_slug/editor_files' do
      exercise = Exercise.new(
        params[:track_slug],
        params[:exercise_slug],
        params[:git_sha]
      )

      json(
        solution_files: exercise.editor_solution_files,
        test_files: []
      )
    end

    get '/exercises/:track_slug/:exercise_slug/code_files' do
      files = Exercise.new(
        params[:track_slug],
        params[:exercise_slug],
        params[:git_sha]
      ).code_files

      json(files: files)
    end

    get '/exercises/:track_slug/:exercise_slug/code_filepaths' do
      filepaths = Exercise.new(
        params[:track_slug],
        params[:exercise_slug],
        params[:git_sha]
      ).code_filepaths

      json(filepaths: filepaths)
    end

    get '/exercises/:track_slug/:exercise_slug/file' do
      exercise = Exercise.new(
        params[:track_slug],
        params[:exercise_slug],
        params[:git_sha]
      )
      content = exercise.read_file_blob(params[:filepath])

      json({
             filepath: params[:filepath],
             content: content
           })
    end

    get '/concepts/:track_slug/:concept_slug/data' do
      data = RetrieveConceptData.(
        params[:track_slug],
        params[:concept_slug],
        params[:git_sha].presence || "HEAD"
      )
      json(concept: data)
    end
  end
end
