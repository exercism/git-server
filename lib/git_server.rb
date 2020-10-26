ENV['APP_ENV'] ||= 'development'

require 'json'
require 'mandate'
require 'singleton'
require 'exercism-config'
require 'rugged'

module GitServer
end

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.push_dir('lib/git_server/models', namespace: GitServer)
loader.push_dir('lib/git_server/commands', namespace: GitServer)
loader.setup

class Object
  def presence
    self if present?
  end

  def present?
    !blank?
  end

  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end
end
