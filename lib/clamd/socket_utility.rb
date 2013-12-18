require 'socket'

module Clamd
  module SocketUtility
    def open_socket
      TCPSocket.open(host, port)
    end

    def close_socket(socket)
      socket.close
    end
  end
end
