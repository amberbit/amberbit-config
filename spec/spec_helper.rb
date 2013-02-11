require 'rubygems'
require 'pry'

require File.expand_path('../dummy/config/environment', __FILE__)

ENV['RAILS_ENV'] = 'test'
ENV['RACK_ENV'] = 'test'
ENV['LANG'] = 'jp'

require 'rspec/rails'

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = Rails.root.join 'spec', 'fixtures'
  config.use_transactional_fixtures = true
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
