#!/usr/bin/env rake

require "bundler/setup"
require "rspec/core/rake_task"

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load "rails/tasks/engine.rake"

RSpec::Core::RakeTask.new(:spec)
task :default => :spec
