module Server

  # Represents a single connection to the server.  Uses Actor-based concurrency
  # to maximize performance without having to muck around with all the
  # traditional concurrency issues.
  class Connection
    extend Actorize

    def initialize(socket)
      @socket = socket
      message_loop
    end

    # Loops forever waiting for new messages to arrive in its mailbox.
    def message_loop
      @socket.controller = Actor.current
      @socket.active = :once

      loop do
        Actor.receive do |filter|
          filter.when(T[:tcp, @socket]) do |_, _, message|
            @socket.active = :once
            puts "Message received: " + message.inspect
          end
        end
      end
    end
  end
end
