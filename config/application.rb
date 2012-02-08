require File.expand_path("../boot", __FILE__)

require "rails/all"
require "amberbit-config"

Bundler.require(:default, Rails.env) if defined?(Bundler)

module DemoApp
    class Application < Rails::Application
        config.encoding = "utf-8"
        config.filter_parameters += [:password]
    end
end
