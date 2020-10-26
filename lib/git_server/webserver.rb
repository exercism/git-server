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

    get '/exercises/:track_slug/:exercise_slug/:git_sha' do
      data = RetrieveExerciseData.(
        params[:track_slug],
        params[:exercise_slug],
        params[:git_sha]
      )
      json(exercise: data)
    end
  end
end
