

require 'pp'    ## pretty print (pp)


class Contract
  class Event; end   ## base class for events

  ## blockchain message (msg) context
  ##   includes:  sender (address)
  ##  todo: allow writable attribues e.g. sender - why? why not?
  class Msg
    attr_reader :sender

    def initialize( sender: '0x0000' )
      @sender = sender
    end
  end  # class Msg


  def self.msg
      @@msg ||= Msg.new
  end

  def self.msg=( value )
    if value.is_a? Hash
      kwargs = value
      @@msg = Msg.new( kwargs )
    else   ## assume Msg class/type
      @@msg = value
    end
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

  def destroy( owner )   ## todo/check: use a different name e.g. destruct/ delete - why? why not?
     ## selfdestruct function (for clean-up on blockchain)
     ## fix: does nothing for now - add some code (e.g. cleanup)
     ##  mark as destruct - why? why not?
  end

  def send_transaction( method, *args )
      __send__( method, *args )   ## note: use __send__ (instead of send - might be overriden)
      ## todo/fix: add send_tx alias - why? why not?
  end


end  # class Contract
