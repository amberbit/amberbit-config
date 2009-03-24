require "ostruct"

# Defines HashStruct class, which is simply OpenStruct and has additional 
# accessor mode via square brackets like hashes
class HashStruct < OpenStruct
  def [](key)
    self.send key
  end
end

class Object
  def to_hashstruct
    self
  end
end

class Array
  def to_hashstruct
    map { |el| el.to_hashstruct }
  end
end

class Hash
  def to_hashstruct
    mapped = {}
    each { |key,value| mapped[key] = value.to_hashstruct }
    HashStruct.new(mapped)
  end
end

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
#   AppConfig['my_app_name']
#   > "Super App"
#
module AmberBitAppConfig

  # Recursivelly merges two hashes
  def self.special_merge!(h1, h2)
    h2.each do |key, new_val|
      if new_val.is_a? Hash
        h1[key] = special_merge!(h1[key] || {}, new_val)
      else
        h1[key] = new_val
      end
    end
    h1
  end

  # Loads YAML file, converts it's values to Hash and merges with current config hash 
  # passed as 2nd parameter. Merged hash of options is returned by this method.
  def self.process_config(file, current_config = nil)
    new_config = YAML.load_file(file) || {}
    default_config = new_config['default']
    env_config = new_config[Rails.env]

    config =
    if default_config.nil? && env_config.nil?
      {}
    elsif default_config.nil? && !env_config.nil?
      env_config
    elsif !default_config.nil? && env_config.nil?
      default_config
    elsif !default_config.nil? && !env_config.nil?
      special_merge!(default_config, env_config)
    else
      raise "You shouldn't get here!"
    end

    if current_config.nil?
      config
    else
      special_merge!(current_config, config)
    end
  end

  def self.initialize
    default_file = File.join(Rails.root, 'config', 'application', 'default.yml')
    config = process_config(default_file)
    config_file = File.join(Rails.root, 'config', 'application', 'config.yml')
    if File.exist? config_file
      config = process_config(config_file, config)
    end
    Object.const_set('AppConfig', config.to_hashstruct)
  end
end
