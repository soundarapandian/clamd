require 'clamd/socket_utility'
require 'clamd/instream_helper'

module Clamd
  module Command
    COMMAND = {
      :ping => "PING",
      :version => "VERSION",
      :reload => "RELOAD",
      :shutdown => "SHUTDOWN",
      :scan => "SCAN",
      :contscan => "CONTSCAN",
      :multiscan => "MULTISCAN",
      :instream => "zINSTREAM\0",
      :stats => "zSTATS\0" }.freeze

    include SocketUtility
    include InstreamHelper

    def exec(command, path=nil)
      begin
        socket = open_socket
        if path && command != COMMAND[:instream]
          socket.write("#{command} #{path}")
        else
          socket.write(command)
        end
        stream_to_clamd(socket, path) if command == COMMAND[:instream]
        socket.recv(clamd_response_size(command))
      ensure
        close_socket(socket) if socket
      end
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
