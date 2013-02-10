require "yaml"
require "ostruct"
require "amberbit-config/engine"

module AmberbitConfig
  class HashStruct < ::OpenStruct
    def [](key)
      self.send key unless key == nil
    end

    def self.create(object)
      case object
      when Array
        object.map { |item| create(item) }
      when Hash
        mapped = {}
        object.each { |key, value| mapped[key] = create(value) }
        HashStruct.new mapped
      else
        object
      end
    end
  end

  class Config
    attr_reader :default, :custom, :data

    def initialize(defaults_file, customs_file)
      @default = parse_yaml defaults_file
      @custom  = parse_yaml customs_file

      @data = deep_merge! default, custom
    end

    private

    def parse_yaml(file)
      config = YAML.load_file(file) || {}
      env    = defined?(Rails) ? Rails.env : ENV['RAILS_ENV'] || ENV['RACK_ENV']

      config_from config['default'], config[env]
    end

    def config_from(default_config, env_config)
      if default_config.present? && env_config.present?
        deep_merge! default_config, env_config
      else
        env_config || default_config || {}
      end
    end

    def deep_merge!(origin = {}, from = {})
      from.each do |key, value|
        origin[key] = value.is_a?(Hash) ? deep_merge!(origin[key], value) : value
      end

      origin
    end
  end

  # Initialize configuration for application
  def self.initialize(default_file = Rails.root.join('config', 'app_config_default.yml'), config_file = Rails.root.join('config', 'app_config.yml'))
    return unless File.exist?(default_file)
    return if defined?(AppConfig)

    config = Config.new default_file, config_file
    Object.const_set 'AppConfig', HashStruct.create(config.data)
  end
end
