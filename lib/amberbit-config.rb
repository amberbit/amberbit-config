require "yaml"
require "ostruct"
require "amberbit-config/engine"

class HashStruct < OpenStruct
    def [](key)
        self.send key unless key == nil
    end
end

module AmberbitConfig
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

    def self.special_merge!(h1, h2)
        h2.each do |key, new_val|
            h1[key] = new_val.is_a?(Hash) ? special_merge!(h1[key] || {}, new_val) : new_val
        end
        h1
    end

    def self.process_config(file, current_config = nil)
        new_config = YAML.load_file(file) || {}
        default_config = new_config["default"]

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

    def self.initialize(default_file = File.join(Rails.root, "config", "app_config_default.yml"), config_file = File.join(Rails.root, "config", "app_config.yml"))
        return unless File.exist?(default_file)
        return if defined?(AppConfig)

        config = process_config(default_file)

        if File.exist? config_file
            config = process_config(config_file, config)
        end

        Object.const_set("AppConfig", to_hashstruct(config))
    end
end
