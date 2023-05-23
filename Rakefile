# frozen_string_literal: true

# When run from within the docker container, also include the standard rails tasks.
if File.exist?("/.dockerenv")
  # require_relative "config/application"
  # Rails.application.load_tasks
  #
  # require "rspec/core/rake_task"
  # RSpec::Core::RakeTask.new(:spec)
end

require "bundler/gem_tasks"

def shell(command)
  print "#{command}\n"
  system command
end

task :default => :tests

task :tests => [:rspec, :rubocop]

desc "Build the docker containers to run development and test scripts"
task :build do
  shell "docker compose build"
end

desc "Run 'bundle install' within docker in order to update Gemfile.lock"
task :bundle do
  shell "docker compose run rails_base bundle install"
  shell "rake build"
end

desc "[alias] Run 'bundle install' within docker in order to update Gemfile.lock"
task :install => :bundle

desc "Run rspec specs"
task :rspec do
  shell "docker compose run rails_base bundle exec rspec spec"
end

desc "[alias] Run rspec specs"
task :spec => :rspec

desc "Run rubocop code linter"
task :rubocop do
  shell "docker compose run rails_base bundle exec rubocop"
end
