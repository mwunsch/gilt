require "bundler/gem_tasks"
require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--color", "--format=documentation"]
end
