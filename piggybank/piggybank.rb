#############################
# Piggy Bank Contract

def initialize
  @owner    = msg.sender
  @deposits = 0 
end
       
def deposit               # payable 
  assert msg.value > 0    # check whether ether was actually sent 
  @deposits +=  1
end
    
def kill
 assert msg.sender == @owner
 selfdestruct( @owner ) 
 # when the account which instantiated this contract calls it again, it terminates and sends back its balance
end
