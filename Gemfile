source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rake"
gem 'sinatra'
gem 'sinatra-contrib'
gem 'puma'
gem 'zeitwerk'
gem 'aws-sdk-dynamodb', '~> 1.51'
gem 'mandate'
gem 'exercism-config', '>= 0.42.0'
gem 'rugged' # Git

group :development, :test do
  gem 'parallel'
  gem 'rack-test'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-performance'
  gem 'simplecov', '~> 0.17.0'
  gem 'timecop'
  gem "mocha"
  gem "minitest"

  # This is needed for exercism_config
  # to set things up in CI-land
  gem 'aws-sdk-s3'
end
