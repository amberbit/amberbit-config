# Defines class used for storing application-wide setting values.
# == Usage:
#
# Say, config/applications/default.yml looks like this:
#
#   default:
#     my_app_name: Super App
#
# Then in your ruby code:
#
#   AppConfig['my_app_name'] #=> "Super App"
#
#   or
#
#   AppConfig.my_app_name #=> "Super App"
#
module AmberBitAppConfig
  # Turns object into HashStruct object or array of HashStructs
  def self.to_hashstruct(object)
    case object
    when Array
      object.map { |el| to_hashstruct(el) }
    when Hash
      mapped = {}
      object.each { |key,value| mapped[key] = to_hashstruct(value) }
      HashStruct.new(mapped)
    when Object
      object
    end
  end

  # Recursivelly merges two hashes
  def self.special_merge!(h1, h2)
    h2.each do |key, new_val|
      h1[key] = new_val.is_a?(Hash) ? special_merge!(h1[key] || {}, new_val) : new_val
    end
    h1
  end

  # Loads YAML file, converts it's values to Hash and merges with current config hash
  # passed as 2nd parameter. Merged hash of options is returned by this method.
  def self.process_config(file, current_config = nil)
    new_config = YAML.load_file(file) || {}
    default_config = new_config['default']

    env_config = defined?(Rails) ? new_config[Rails.env] : nil

    config =
    if default_config.nil? && env_config.nil?
      {}
    elsif default_config.nil? && !env_config.nil?
      env_config
    elsif !default_config.nil? && env_config.nil?
      default_config
    elsif !default_config.nil? && !env_config.nil?
      special_merge!(default_config, env_config)
    end

    current_config.nil? ? config : special_merge!(current_config, config)
  end

  def self.initialize(default_file = File.join(Rails.root, 'config', 'application', 'default.yml'),
                      config_file = File.join(Rails.root, 'config', 'application', 'config.yml'))

    return unless File.exist?(default_file)

    config = process_config(default_file)
    if File.exist? config_file
      config = process_config(config_file, config)
    end
    Object.const_set('AppConfig', to_hashstruct(config))
  end
end

