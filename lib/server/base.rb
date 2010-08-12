module Server

  # Controls initial construction and starting of a new server instance.
  class Base

    # Start a new server with the specified options.  This method will loop
    # forever waiting for new connections, so it will not return.
    def self.start(options)
      listener = Actor::TCP.listen(options[:host], options[:port], :filter => Server::RSFilter)
      loop { Server::Connection.spawn(listener.accept) }
    end
  end
end
