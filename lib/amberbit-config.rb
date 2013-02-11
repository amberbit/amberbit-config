require 'amberbit-config/version'
require 'amberbit-config/errors'
require 'amberbit-config/config'
require 'amberbit-config/hash_struct'
require 'amberbit-config/engine' if defined?(::Rails::Engine)

module AmberbitConfig
  # Initialize AppConfig variable with default file path and custom file path if it wasn't set yet.
  def self.initialize(default_file, config_file)
    return unless File.exist?(default_file)
    return if defined?(AppConfig)

    config = Config.new default_file, config_file
    Object.const_set 'AppConfig', HashStruct.create(config.data)
  end

  # Run initialze with default file names within root_path
  def self.initialize_within(root_path)
    initialize path_from(root_path, 'app_config_default.yml'), path_from(root_path, 'app_config.yml')
  end

  # Gets path from root_path and file name, i.e.
  # <tt>path_from File.dirname(__FILE__), 'app_config.yml'</tt>
  def self.path_from(root_path, file)
    File.expand_path File.join(File.dirname(root_path), 'config', file)
  end
end
