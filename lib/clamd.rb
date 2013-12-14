require "clamd/client"
require "clamd/configuration"
require "clamd/version"

module Clamd
  NAME = 'clamd'

  def self.configure
    @configuration ||= Configuration.new

    yield(@configuration) if block_given?

    @configuration
  end

  def self.configuration
    @configuration
  end

  # Configure defaults
  configure
end
