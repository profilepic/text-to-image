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


require 'universum'


#  Recorder — record (tattoo) a message into the blockchain (forever)

class Recorder < Contract

  Record = Event.new( :from, :message )   ## type address _from, string _message
  
  ## Sends the contract a message
  ##  to record (tattoo) into the blockchain (forever)
  def record( message )
    log Record.new( msg.sender,  message )
  end
end



#############
#  start testing...

if __FILE__ == $0

Account[ '0x1111' ]
Account[ '0xaaaa' ]
Account[ '0xbbbb' ]

# genesis - create contract
recorder = Uni.send_transaction( from: '0x1111', data: Recorder ).contract

Uni.send_transaction( from: '0x1111', to: recorder, data: [:record, 'Hello, Universum!'] )
Uni.send_transaction( from: '0xaaaa', to: recorder, data: [:record, 'Alice was here!'] )
Uni.send_transaction( from: '0xbbbb', to: recorder, data: [:record, 'Ruby rocks!'] )

# genesis - creae contract
recorder_de = Uni.send_transaction( from: '0x1111', data: Recorder ).contract

Uni.send_transaction( from: '0x1111', to: recorder_de, data: [:record, 'Hallo, Weltall!'] )
Uni.send_transaction( from: '0xaaaa', to: recorder_de, data: [:record, 'Alice war hier!'] )
Uni.send_transaction( from: '0xbbbb', to: recorder_de, data: [:record, 'Ruby rockt!'] )

end
