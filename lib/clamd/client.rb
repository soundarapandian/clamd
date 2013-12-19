require 'timeout'
require 'clamd/socket_manager'

module Clamd
  ##
  # == Class that interacts with ClamdAV daemon
  #
  # Clamd::Client is responsible for interacting with ClamdAV daemon.
  #
  # For example you can connect ClamdAV daemon as given below
  #
  #    clamd = Clamd::Client.new
  #    clamd.ping
  #
  # In the above example the ClamdAV daemon details will be get from the
  # Clamd::Configuration
  #
  # You can also override the globla Clamd::Configuration as given below
  #
  #    clamd = Clamd::Client.new(host: '172.15.20.11', port: 8321)
  #    clamd.ping

  class Client
    attr_accessor :host, :port, :open_timeout, :read_timeout, :chunk_size

    ##
    # Supported ClamdAV daemon commands

    COMMAND = {
      ping:       "PING",
      version:    "VERSION",
      reload:     "RELOAD",
      shutdown:   "SHUTDOWN",
      scan:       "SCAN",
      contscan:   "CONTSCAN",
      multiscan:  "MULTISCAN",
      instream:   "zINSTREAM\0",
      stats:      "zSTATS\0"
    }.freeze

    include SocketManager

    def initialize(options = {})
      self.host = options[:host] || Clamd.configuration.host
      self.port = options[:port] || Clamd.configuration.port
      self.open_timeout = options[:open_timeout] || Clamd.configuration.open_timeout
      self.read_timeout = options[:read_timeout] || Clamd.configuration.read_timeout
      self.chunk_size = options[:chunk_size] || Clamd.configuration.chunk_size
    end

    ##
    # Method used to feed PING command to ClamdAV daemon
    #
    # Usage:
    #
    #    clamd = Clamd::Client.new
    #    clamd.ping
    def ping
      exec(COMMAND[:ping])
    end

    ##
    # Method used to feed VERSION command to ClamdAV daemon
    #
    # Usage:
    #
    #    clamd = Clamd::Client.new
    #    clamd.version

    def version
      exec(COMMAND[:version])
    end

    ##
    # Method used to feed RELOAD command to ClamdAV daemon
    #
    # Usage:
    #
    #    clamd = Clamd::Client.new
    #    clamd.reload

    def reload
      exec(COMMAND[:reload])
    end

    ##
    # Method used to feed SHUTDOWN command to ClamdAV daemon
    #
    # Usage:
    #
    #    clamd = Clamd::Client.new
    #    clamd.shutdown
    #
    # Return value: +true+ on success +false+ on failure

    def shutdown
      exec(COMMAND[:shutdown])

      ping =~ /^ERROR: Connection refused.*$/ ? true : false
    end

    ##
    # Method used to feed SCAN command to ClamdAV daemon
    #
    # Usage:
    #
    #    clamd = Clamd::Client.new
    #    clamd.scan('/home/soundar/documents/doc.pdf') (file)
    #    clamd.scan('/home/soundar/documents') (directory)

    def scan(path)
      exec(COMMAND[:scan], path)
    end

    ##
    # Method used to feed CONTSCAN command to ClamdAV daemon
    #
    # Usage:
    #
    #    clamd = Clamd::Client.new
    #    clamd.contscan('/home/soundar/documents/doc.pdf') (file)
    #    clamd.contscan('/home/soundar/documents') (directory)

    def contscan(path)
      exec(COMMAND[:contscan], path)
    end

    ##
    # Method used to feed MULTISCAN command to ClamdAV daemon
    #
    # Usage:
    #
    #    clamd = Clamd::Client.new
    #    clamd.multiscan('/home/soundar/documents/doc.pdf') # file
    #    clamd.multiscan('/home/soundar/documents') # directory

    def multiscan(path)
      exec(COMMAND[:multiscan], path)
    end

    ##
    # Method used to feed INSTREAM command to ClamdAV daemon
    #
    # Usage:
    #
    #    clamd = Clamd::Client.new
    #    clamd.instream('/home/soundar/documents/doc.pdf') # file

    def instream(path)
      exec(COMMAND[:instream], path)
    end

    ##
    # Method used to feed STATS command to ClamdAV daemon
    #
    # Usage:
    #
    #    clamd = Clamd::Client.new
    #    clamd.stats

    def stats
      exec(COMMAND[:stats])
    end

    private

      def exec(command, path=nil)
        begin
          socket = Timeout::timeout(open_timeout) { open_socket(host, port) }
          write_socket(socket, command, path)
          Timeout::timeout(read_timeout) { read_socket(socket, command) }
        rescue Exception => e
          "ERROR: #{e.message.gsub('ERROR', '')}"
        ensure
          close_socket(socket) if socket
        end
      end
  end
end
