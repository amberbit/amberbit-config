require 'ostruct'

module AmberbitConfig
  # Main class that holds whole configuration, acts as open struct, with few tune ups
  class HashStruct < ::OpenStruct
    # Initialize with check for conflicts within hash keys
    def initialize(hash = nil)
      check_hash_for_conflicts hash if hash
      super
    end

    # Adds access to existing keys through hash operator
    def [](key)
      self.send key unless key == nil
    end

    # Generates a nested Hash object which is a copy of existing configuration
    def to_hash
      _copy = {}
      @table.each { |key, value| _copy[key] = value.is_a?(HashStruct) ? value.to_hash : value }
      _copy
    end

    # Raise an error if method/configuration isn't set yet. It should prevent typos, because normally it will just
    # return a nil. With this check you can spot those earlier.
    def method_missing(method, *args, &block)
      if method =~ /=\z/ || self.respond_to?(method)
        super
      else
        raise ConfigNotSetError, "Configuration option: '#{method}' was not set"
      end
    end

    # Creates a deeply nested HashStruct from hash.
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

    private

    # Checks if provided option is a hash and if the keys are not in confict with OpenStruct public methods.
    def check_hash_for_conflicts(hash)
      raise HashArgumentError, 'It must be a hash' unless hash.is_a?(Hash)

      unless (conflicts = self.public_methods & hash.keys.map(&:to_sym)).empty?
        raise HashArgumentError, "Rename keys in order to avoid conflicts with internal calls: #{conflicts.join(', ')}"
      end
    end
  end
end
