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
  end
end
