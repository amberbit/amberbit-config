require "rubygems"

require File.expand_path("../dummy/config/environment", __FILE__)

ENV["RAILS_ENV"] ||= "test"

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require "rspec/rails"

RSpec.configure do |config|
    config.mock_with :rspec
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
end
