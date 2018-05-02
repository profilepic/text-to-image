###
#  coin flip(ping) / heads or tails
#   see https://en.wikipedia.org/wiki/Coin_flipping

## note: NOT secure (random)
##  a contract can be constructed to generate transactions
##   to your contract only in situations where block.timestamp % 2 == 0
##   and, thus, always wins.


class CoinFlip < Contract

  def initialize
    # nothing here
  end

	def double     ## todo/check: use a different name e.g. call/bet/flip etc. why? why not?
		bet  = msg.value
		flip = block.timestamp    ## semirandom
		if flip % 2 == 0
			return
		else
			msg.sender.send( 2 * bet )
	end

end # class CoinFlip
