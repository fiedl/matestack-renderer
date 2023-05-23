# frozen_string_literal: true

# When run from within the docker container, also include the standard rails tasks.
if File.exist?("/.dockerenv")
  # require_relative "config/application"
  # Rails.application.load_tasks
  #
  # require "rspec/core/rake_task"
  # RSpec::Core::RakeTask.new(:spec)
end

def shell(command)
  print "#{command}\n"
  system command
end

task :default => :spec

task :build do
  shell "docker compose build"
end

task :install => :bundle
task :bundle do
  shell "docker compose run rails_base bundle install"
  shell "rake build"
end

require "bundler/gem_tasks"

task :spec do
  shell "docker compose run rails_base rspec spec"
end

