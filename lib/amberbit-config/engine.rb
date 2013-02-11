require 'amberbit-config'

module AmberbitConfig
  class Engine < ::Rails::Engine
    engine_name :amberbit_config

    initializer 'amberbit_config.initialize_config', before: :load_environment_config do |app|
      AmberbitConfig.initialize_within app.root.join('config')
    end

    rake_tasks do
      load 'tasks/amberbit-config.rake'
    end
  end if defined?(::Rails)
end
