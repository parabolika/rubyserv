module Server

  # Encodes and decodes outgoing and incoming data.  Incoming data is stored
  # in an <tt>IO::Buffer</tt> provided by Rev.  To prevent packet
  # fragmentation, ALL incoming data is pushed onto the buffer which is read
  # from until empty, or until not enough data is available.
  class RSFilter
    def initialize
      @buffer = IO::Buffer.new
    end

    # Callback for processing incoming frames
    def decode(data)
      @buffer << data
      @packets = []

      # Loop through the buffer to extract all the available packets.
      begin
        id = @buffer.read(1).unpack('C')[0]
        definition = Server::Packets.packets[id]

        length = definition.length # TODO: Handle variable-length packets.

        # TODO: This probably won't work, as it won't rewrite the data back to
        # the buffer.
        break if @buffer.size < length

        data = @buffer.read(length).unpack('c')

        @packets << [definition.name, extract_named_data(definition, data)]
      end until @buffer.empty?

      @packets
    end

    # Callback for writing outgoing frames
    def encode(*data)
      data
    end

    private

    # Call all methods defined by the <tt>Server::PacketDefinition</tt> that
    # extract data from the buffer on a new instance of
    # <tt>Server::RSInput</tt> and match the output to the specified name.
    def extract_named_data(definition, data)
      named = {}
      input = RSInput.new(data)
      definition.calls.each do |call|
        # Example: call[0] == :u1, call[1] == :name_hash
        named[call[1]] = input.send call[0]
      end
      named
    end
  end

  # Handles all low-level reading from an array of bytes.
  class RSInput
    def initialize(data)
      @data = data
    end

    def s1
      @data.shift
    end

    def u1
      s1 & 0xff
    end
  end
end
