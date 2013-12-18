module Clamd
  module InstreamHelper
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

    def write_chunk(socket, chunk)
      socket.write([chunk.size].pack("N"))
      socket.write(chunk)
    end

    def stop_streaming(socket)
      socket.write([0].pack("N"))
    end
  end
end
