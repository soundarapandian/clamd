module Clamd
  class Configuration
    attr_accessor :host, :port, :open_timeout, :read_timeout, :chunk_size
    DEFAULT_CONFIGURATION = { :open_timeout => 5, :read_timeout => 30, :chunk_size => 10240 } 

    def initialize
      @open_timeout = DEFAULT_CONFIGURATION[:open_timeout] 
      @read_timeout = DEFAULT_CONFIGURATION[:read_timeout]
      @chunk_size = DEFAULT_CONFIGURATION[:chunk_size]
    end
  end

  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration) if block_given?
    missing = []
    missing << "host" unless @configuration.host
    missing << "port" unless @configuration.port
    raise ConfigurationError,
      "Missing configuration: #{missing.join(",")}" unless missing.empty?
    @configuration
  end

  def self.configuration
    @configuration
  end

  def self.configured?
    return true if configuration
    false
  end
  
  class ConfigurationError < StandardError;end
end
