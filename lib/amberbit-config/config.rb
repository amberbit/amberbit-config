require 'erb'
require 'yaml'

module AmberbitConfig
  # Class responsible for loading, parsing and merging configuration from yaml files.
  class Config
    attr_reader :default, :custom, :data

    def initialize(defaults_file, customs_file)
      @default = parse_yaml defaults_file
      @custom  = parse_yaml customs_file

      @data = deep_merge default, custom
    end

    private

    # Parse configuration file with ERB so you can set keys like:
    # <tt>redis_url: <%= ENV['REDIS_URL'] %></tt>
    # then loads a hash and merges defaults with current environment
    def parse_yaml(file)
      file_content = File.exist?(file) ? ERB.new(File.read(file)).result : '---'

      config = YAML.load(file_content) || {}
      env    = ENV['RAILS_ENV'] || ENV['RACK_ENV'] || ENV['APP_CONFIG_ENV']

      config_from config['default'], config[env]
    end

    def config_from(default_config, env_config)
      if present?(default_config) && present?(env_config)
        deep_merge default_config, env_config
      else
        env_config || default_config || {}
      end
    end

    def deep_merge(origin, from)
      origin ||= {}
      from   ||= {}
      deep_merge!(origin.dup, from)
    end

    def deep_merge!(origin, from)
      from.each do |key, value|
        origin[key] = value.is_a?(Hash) ? deep_merge(origin[key], value) : value
      end

      origin
    end

    def present?(object)
      !blank?(object)
    end

    def blank?(object)
      object.respond_to?(:empty?) ? object.empty? : !object
    end
  end
end
