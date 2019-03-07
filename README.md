New to Universum? See the [Universum (World Computer) White Paper](https://github.com/s6ruby/universum/blob/master/WHITEPAPER.md)!



# Universum blockhain contract / transaction scripts

(in plain vanilla / standard ruby)
for the next generation ethereum 2.0 world computer



Ruby (Universum Blockchain Contract Script Language) Example

``` ruby
###########################
# Gav Token Contract

TOTAL_TOKENS = 100_000_000_000

## Endows creator of contract with 1m GAV.
def setup
  @balances = Mapping.of( Address => Money )
  @balances[msg.sender] = TOTAL_TOKENS
end

## Send $((valueInmGAV / 1000).fixed(0,3)) GAV from the account of
##    $(message.caller.address()), to an account accessible only by $(to.address()).
def send( to, value )
  assert @balances[msg.sender] >= value
  @balances[to]         += value
  @balances[msg.sender] -= value
end

## getter function for the balance
def balance( who )
   @balances[who]
end
```

vs

Solidity (JavaScript-Like Ethereum Blockchain Contract Script Language) Example

``` solidity
contract GavToken
{
  mapping(address=>uint) balances;
  uint constant totalTokens = 100000000000;

  /// Endows creator of contract with 1m GAV.
  function GavToken(){
      balances[msg.sender] = totalTokens;
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
def transfer(_to: address, _value: int128(uint256)) -> bool:

    assert self.balances[msg.sender] >= _value
    assert self.balances[_to] + _value >= self.balances[_to]

    self.balances[msg.sender] -= _value  # Subtract from the sender
    self.balances[_to] += _value  # Add the same to the recipient
    log.Transfer(msg.sender, _to, convert(_value, 'uint256'))  # log transfer event.

    return True

# ...
```

vs

Ruby (Universum Blockchain Contract Script Language) Example

``` ruby
######################
# Token Contract

event :Transfer, :from, :to, :value
event :Approval, :owner, :spender, :value
 
def setup( name, symbol, decimals, initial_supply )
  @name     = name
  @symbol   = symbol
  @decimals = decimals
  @total_supply =  initial_supply * (10 ** decimals)
  @balances     =  Mapping.of( Address => Money )
  @balances[msg.sender] = @total_supply
  @allowed      =  Mapping.of( Adress => Mapping.of( Address => Money ))
end


# What is the balance of a particular account?
def balance_of( owner )
  @balances[owner]
end

# Send `_value` tokens to `_to` from your account
def transfer( to, value )
  assert @balances[msg.sender] >= value
  assert @balances[to] + value >= @balances[to]

  @balances[msg.sender] -= value  # Subtract from the sender
  @balances[to]         += value  # Add the same to the recipient

  log Transfer.new( msg.sender, to, value )   # log transfer event.

  true
end

## ...
```
