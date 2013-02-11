require 'rubygems'

ENV['RAILS_ENV'] = ENV['RACK_ENV'] = 'test'
ENV['LANG'] = 'jp'

require 'rspec'
require_relative '../lib/amberbit-config'

RSpec.configure do |config|
  config.mock_with :rspec
end

# some helpers for fixtures
def path_for(config);   File.expand_path(File.join('../fixtures', config), __FILE__) ;end
def empty;              path_for 'empty.yml'              ;end
def app_config;         path_for 'app_config.yml'         ;end
def app_config_default; path_for 'app_config_default.yml' ;end

RSpec::Matchers.define :have_constant do |const|
  match do |owner|
    owner.const_defined?(const)
  end
end
