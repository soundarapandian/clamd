require "clamd/client"
require "clamd/configuration"
require "clamd/version"

module Clamd
  ##
  # Used to configure the Clamd globally
  #
  # Usage:
  #
  #    Clamd.configure do |config|
  #      config.host = 'localhost'
  #      config.port = 9321
  #      config.open_timeout = 5
  #      config.read_timeout = 10
  #      config.chunk_size = 10240
  #    end
  def self.configure
    @configuration ||= Configuration.new

    yield(@configuration) if block_given?

    @configuration
  end

  ##
  # Gets current configuration details of Clamd

  def self.configuration
    @configuration
  end

  # Configure defaults
  configure
end
