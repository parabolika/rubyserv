module Server

  # Represents a single packet that will be read or written at some point.  This
  # does not store any data about a particular packet received, rather the
  # layout of how a particular type of packet.
  #
  # == Example
  #  # Will define a new packet definition with an ID of 2, a length of 5, and
  #  # a name of 'login'.  It will contain two data structures: a byte called
  #  # 'some_variable', and a short named 'another_variable', both unsigned.
  #  p = PacketDefinition.new(2, 5, :login) do
  #    u1 :some_variable
  #    u2 :another_variable
  #  end
  class PacketDefinition
    attr_reader :id, :length, :name, :calls

    def initialize(id, length, name, &block)
      @id, @length, @name = id, length, name
      @calls = []
      instance_eval(&block)
    end

    def method_missing(name, *args)
      @calls << [name, *args]
    end
  end
end
