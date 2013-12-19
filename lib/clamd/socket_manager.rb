require 'socket'

module Clamd
  module SocketManager
    ##
    # Opens socket for the given +host+ and +port+

    def open_socket(host, port)
      TCPSocket.open(host, port)
    end

    ##
    # Closes the given socket

    def close_socket(socket)
      socket.close
    end

    ##
    # Reads the response for the given command from the socket

    def read_socket(socket, command)
      socket.recv(clamd_response_size(command)).gsub(/(\u0000)|(\n)/, "").strip
    end

    ##
    # Writes the command to the given sicket

    def write_socket(socket, command, path)
      if path && command != "zINSTREAM\0"
        socket.write("#{command} #{path}")
      else
        socket.write(command)
      end
      stream_to_clamd(socket, path) if command == "zINSTREAM\0"
    end

    ##
    # Determines the number of bytes to be read for the command

    def clamd_response_size(command)
      case command
      when 'PING'
        4
      when 'RELOAD'
        9
      when 'SHUTDOWN'
        1
      else
        1024
      end
    end

    ##
    # Streams file content to the ClamAV daemon

    def stream_to_clamd(socket, path)
      begin
        file = File.open(path, "rb")
        bytes = file.read(chunk_size)

        while bytes
          write_chunk(socket, bytes)
          bytes = file.read(chunk_size)
        end
        stop_streaming(socket)
      ensure
        file.close if file
      end
    end

    ##
    # Writes the size of chunk(bytes), chunk(bytes) to the socket

    def write_chunk(socket, chunk)
      socket.write([chunk.size].pack("N"))
      socket.write(chunk)
    end

    ##
    # Stops streaming to ClamAV daemon

    def stop_streaming(socket)
      socket.write([0].pack("N"))
    end
  end
end
