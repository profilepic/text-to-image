

require 'pp'    ## pretty print (pp)


class Contract
  class Event; end   ## base class for events

  ## blockchain message (msg) context
  ##   includes:  sender (address)
  class Msg
    attr_reader :sender

    def initialize( sender: )
      @sender = sender
    end
  end  # class Msg

  def self.msg( **kwargs )
    if kwargs.empty?
      @@msg ||= Msg.new( sender: '0x0000' )
    else
      ## allow convenience shortcut e.g.
      ##   Contract.msg( sender: '0x0000') # instead of
      ##   Contract.msg = Contract::Msg.new( sender: '0x0000' )
      @@msg = Msg.new( kwargs )
    end
  end

  def self.msg=( value )
    @@msg = value
  end

  def msg() self.class.msg; end


  def self.handlers    ## use listeners/observers/subscribers/... - why? why not?
    @@handlers ||= []
  end


  def self.log( event )
    handlers.each { |h| h.handle( event ) }
  end

  def log( event ) self.class.log( event ); end


  def assert( cond )
    cond == true ? true : false
  end

end  # class Contract
