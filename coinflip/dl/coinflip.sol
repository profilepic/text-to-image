contract CoinFlip {

	function CoinFlip() {
		// nothing here
	}

 function() {
		var bet = msg.value;
		var flip = block.timestamp;    // semirandom
		if( flip % 2 == 0 )
			return;
		else
			msg.sender.send( 2 * bet );
	}
}


// note: NOT secure (random)
//  a contract can be constructed to generate transactions
//   to your contract only in situations where block.timestamp % 2 == 0
//   and, thus, always wins.
