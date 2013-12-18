require 'timeout'
require 'clamd/socket_manager'

module Clamd
  class Client
    attr_accessor :host, :port, :open_timeout, :read_timeout, :chunk_size
    include Commands
    include SocketManager

    def initialize(options = {})
      self.host = options[:host] || Clamd.configuration.host
      self.port = options[:port] || Clamd.configuration.port
      self.open_timeout = options[:open_timeout] || Clamd.configuration.open_timeout
      self.read_timeout = options[:read_timeout] || Clamd.configuration.read_timeout
      self.chunk_size = options[:chunk_size] || Clamd.configuration.chunk_size
    end

    def ping
      exec(COMMAND[:ping])
    end

    def version
      exec(COMMAND[:version])
    end

    def reload
      exec(COMMAND[:reload])
    end

    def shutdown
      exec(COMMAND[:shutdown])

      ping =~ /^ERROR: Connection refused.*$/ ? true : false
    end

    def scan(path)
      exec(COMMAND[:scan], path)
    end

    def contscan(path)
      exec(COMMAND[:contscan], path)
    end

    def multiscan(path)
      exec(COMMAND[:multiscan], path)
    end

    def instream(path)
      exec(COMMAND[:instream], path)
    end

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
