module Server
  module Packets
    def self.packets
      @packets
    end

    private

    # Shorthand for defining a new packet definition and adding it to the
    # definitions list.
    def self.define(id, length, name, &block)
      definition = Server::PacketDefinition.new id, length, name, &block
      (@packets ||= {})[definition.id] = definition
    end

    define(14, 1, :handshake_in) do
      u1 :name_hash
    end
  end
end
