require 'socket'

module Clamd
  module SocketUtility
    def open_socket
      TCPSocket.open(Clamd.configuration.host, Clamd.configuration.port)
    end

    def close_socket(socket)
      socket.close
    end
  end
end
