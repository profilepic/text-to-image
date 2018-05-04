##
#  adapted ruby version (for universum)
#
# forever message recorder contract sample
#   from Full-stack smart contract development
#    see https://hackernoon.com/full-stack-smart-contract-development-fccdfe5176ce
#
#
#  to test the contract script run:
#   $ ruby forever/forever.rb


require_relative '../lib/universum'





#  Recorder — record (tatoo) a message into the blockchain (forever)

class Recorder < Contract

  class Record < Event
    def initialize( from, message )   ## address _from, string _message
      @from, @message = from, message
    end
  end

  ## Sends the contract a message
  ##  to record (tatoo) into the blockchain (forever)
  def record( message )
    log Record.new( msg.sender,  message )
  end
end



#############
#  start testing...

if __FILE__ == $0

recorder = Recorder.new
recorder

recorder.record( 'Hello, Universum!' )
recorder.record( 'Alice was here!' )
recorder.record( 'Ruby rocks!')


##################
## use/try send_transaction   -- change to/use transact - why? why not?

recorder_de = Recorder.new

recorder_de.send_transaction( :record, 'Hallo, Weltall!' )
recorder_de.send_transaction( :record, 'Alice war hier!' )
recorder_de.send_transaction( :record, 'Ruby rockt!' )

end
