require "rails"
require "amberbit-config"

module AmberbitConfig
    class Engine < Rails::Engine
        engine_name :amberbit_config

        rake_tasks do
            load "tasks/amberbit-config.rake"
        end
    end
end
