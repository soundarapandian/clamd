require 'socket'

module Clamd
  module SocketUtility
    def open_socket
      TCPSocket.open("localhost", 9321)
    end

    def close_socket(socket)
      socket.close
    end
  end
end
