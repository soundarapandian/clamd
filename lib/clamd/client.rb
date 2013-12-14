require 'timeout'
require 'clamd/socket_utility'
require 'clamd/instream_helper'

module Clamd
  class Client
    COMMAND = {
      :ping => "PING",
      :version => "VERSION",
      :reload => "RELOAD",
      :shutdown => "SHUTDOWN",
      :scan => "SCAN",
      :contscan => "CONTSCAN",
      :multiscan => "MULTISCAN",
      :instream => "zINSTREAM\0",
      :stats => "zSTATS\0"
    }.freeze

    include SocketUtility
    include InstreamHelper

    def exec(command, path=nil)
      begin
        socket = Timeout::timeout(Clamd.configuration.open_timeout) { open_socket }
        write_socket(socket, command, path)
        Timeout::timeout(Clamd.configuration.read_timeout) { read_socket(socket, command) }
      rescue Errno::ECONNREFUSED
        "ERROR: Failed to connect to Clamd daemon"
      rescue Errno::ECONNRESET, Errno::ECONNABORTED, Errno::EPIPE
        "ERROR: Connection with Clamd daemon closed unexpectedly"
      rescue Timeout::Error
        "ERROR: Timeout error occurred"
      ensure
        close_socket(socket) if socket
      end
    end
    
    def read_socket(socket, command)
      socket.recv(clamd_response_size(command)).gsub(/(\u0000)|(\n)/, "")
    end

    def write_socket(socket, command, path)
      if path && command != COMMAND[:instream]
        socket.write("#{command} #{path}")
      else
        socket.write(command)
      end
      stream_to_clamd(socket, path) if command == COMMAND[:instream]
    end

    def clamd_response_size(command)
      case command
      when COMMAND[:ping]
        4
      when COMMAND[:reload]
        9
      when COMMAND[:shutdown]
        1
      else
        1024
      end
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
  end
end
