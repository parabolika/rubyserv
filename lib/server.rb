libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include? libdir

require 'revactor'

require 'server/base'
require 'server/packet'
require 'server/packets'
require 'server/filter'
require 'server/connection'

module Server
  DEFAULT_OPTS = { :host => 'localhost', :port => 43594 }

  def self.setup(options={})
    Server::Base.start(DEFAULT_OPTS.merge(options))
  end
end
