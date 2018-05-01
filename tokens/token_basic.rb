## adapted ruby version (for universum)
#
# original ethereum solidity
#  see https://en.wikipedia.org/wiki/Solidity
#
#
#  to test the contract script run:
#   $ ruby tokens/token_basic.rb



require_relative '../lib/universum'


class GavToken < Contract

  TOTAL_TOKENS = 100_000_000_000

  ## Endows creator of contract with 1m GAV.
  def initialize
    @balances = Hash.new(0)   ## note: special hash (default value is 0 and NOT nil)
    @balances[msg.sender] = TOTAL_TOKENS
  end

  ## Send $((valueInmGAV / 1000).fixed(0,3)) GAV from the account of
  ##    $(message.caller.address()), to an account accessible only by $(to.address()).
  def send( to, value )   ## address to, uint256 valueInmGAV
    if @balances[msg.sender] >= value
         @balances[to]         += value
         @balances[msg.sender] -= value
    end
  end

  ## getter function for the balance
  def balance( who )  ## (address who) constant returns (uint256 balanceInmGAV)
    @balances[who]
  end
end # class GavToken




#############
#  start testing...

if __FILE__ == $0

token = GavToken.new
pp token


pp token.balance( '0x0000' )
pp token.balance( '0x1111' )

pp token.send( '0x1111', 100 )
pp token.balance( '0x1111' )

pp token.send( '0x2222', 200 )
pp token.balance( '0x2222' )
pp token.balance( '0x0000' )


##################
## use/try send_transaction

pp token.send_transaction( :balance, '0x0000' )
pp token.send_transaction( :balance, '0x1111' )

pp token.send_transaction( :send, '0x1111', 100 )
pp token.send_transaction( :balance, '0x1111' )

pp token.send_transaction( :send, '0x2222', 200 )
pp token.send_transaction( :balance, '0x2222' )
pp token.send_transaction( :balance, '0x0000' )

end
