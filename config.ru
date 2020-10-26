$stdout.sync = true
$stderr.sync = true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)

require_relative "lib/git_server"

run GitServer::Webserver
