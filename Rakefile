require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'doc', '--format', 'Nc']
end

task :default => :spec

require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

