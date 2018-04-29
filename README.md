# Universum blockhain contract / transaction scripts

(in plain vanilla / standard ruby)
for the next generation ethereum 2.0 world computer



Ruby (Universum Blockchain Contract Script Language) Example

``` ruby
class GavCoin < Contract

  TOTAL_COINS = 100_000_000_000

  ## Endows creator of contract with 1m GAV.
  def initialize
    @balances = {}
    @balances[msg.sender] = TOTAL_COINS
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
```

vs

Solidity (JavaScript-Like Ethereum Blockchain Contract Script Language) Example

``` solidity
contract GavCoin
{
  mapping(address=>uint) balances;
  uint constant totalCoins = 100000000000;

  /// Endows creator of contract with 1m GAV.
  function GavCoin(){
      balances[msg.sender] = totalCoins;
  }

  /// Send $((valueInmGAV / 1000).fixed(0,3)) GAV from the account of
  ///   $(message.caller.address()), to an account accessible only by $(to.address()).
  function send(address to, uint256 valueInmGAV) {
    if (balances[msg.sender] >= valueInmGAV) {
      balances[to] += valueInmGAV;
      balances[msg.sender] -= valueInmGAV;
    }
  }

  /// getter function for the balance
  function balance(address who) constant returns (uint256 balanceInmGAV) {
    balanceInmGAV = balances[who];
  }
}
```


Vyper (Python-Like Ethereum Blockchain Contract Script Language) Example

``` py

Transfer: event({_from: indexed(address), _to: indexed(address), _value: uint256})
Approval: event({_owner: indexed(address), _spender: indexed(address), _value: uint256})


# Variables of the token.
name: public(bytes32)
symbol: public(bytes32)
totalSupply: public(uint256)
decimals: public(uint256)
balances: int128[address]
allowed: int128[address][address]

@public
def __init__(_name: bytes32, _symbol: bytes32, _decimals: uint256, _initialSupply: uint256):

    self.name = _name
    self.symbol = _symbol
    self.decimals = _decimals
    self.totalSupply = uint256_mul(_initialSupply, uint256_exp(convert(10, 'uint256'), _decimals))
    self.balances[msg.sender] = convert(self.totalSupply, 'int128')


# What is the balance of a particular account?
@public
@constant
def balanceOf(_owner: address) -> uint256:

    return convert(self.balances[_owner], 'uint256')


# Send `_value` tokens to `_to` from your account
@public
def transfer(_to: address, _amount: int128(uint256)) -> bool:

    assert self.balances[msg.sender] >= _amount
    assert self.balances[_to] + _amount >= self.balances[_to]

    self.balances[msg.sender] -= _amount  # Subtract from the sender
    self.balances[_to] += _amount  # Add the same to the recipient
    log.Transfer(msg.sender, _to, convert(_amount, 'uint256'))  # log transfer event.

    return True

# ...
```

vs

Ruby (Universum Blockchain Contract Script Language) Example

``` ruby
class Token < Contract

  class Transfer < Event
    def initialize( from:, to:, value: )
      @from, @to, @value = from, to, value
    end
  end

  class Approval < Event
    def initialize( owner:, spender:, value: )
      @owner, @spender, @value = owner, spender, value
    end
  end


  def initialize( name:, symbol:, decimals:, initial_supply: )
    @name     = name
    @symbol   = symbol
    @decimals = decimals
    @total_supply =  initial_supply * (10 ** decimals)
    @balances     = Hash.new(0)    ## note: special hash (default value is 0 and NOT nil)
    @balances[msg.sender] = @total_supply
    @allowed =   {}
  end


  # What is the balance of a particular account?
  def balance_of( owner: )
    @balances[owner]
  end

  # Send `_value` tokens to `_to` from your account
  def transfer( to:, value: )
    if assert( @balances[msg.sender] >= value ) &&
       assert( @balances[to] + value >= @balances[to] )

      @balances[msg.sender] -= value  # Subtract from the sender
      @balances[to]         += value  # Add the same to the recipient

      log Transfer.new( from: msg.sender, to: to, value: value )   # log transfer event.

      true
    else
      false
    end
  end

## ...

end # class Token
```
