## adapted ruby version
#
# original ethereum Vyper Port of MyToken
#  see https://github.com/ethereum/vyper/blob/master/examples/tokens/vypercoin.v.py



require 'pp'    ## pretty print (pp)


class Contract
  class Event; end   ## base class for events

  ## blockchain message (msg) context
  ##   includes:  sender (address)
  class Msg
    def sender
      '0x00000000000000000'  ## fix
    end
  end

  def self.msg
    @@msg ||= Msg.new
  end

  def self.msg=(value)
    @@msg = value
  end

  def msg() self.class.msg; end



end  # class Contract



class Token < Contract


# Events of the token.
  class Transfer < Event
    def initialize( from:, to:, value: )  ## _from: indexed(address), _to: indexed(address), _value: uint256
    end
  end
  class Approval < Event
    def initialize( owner:, spender:, value: )  ##  _owner: indexed(address), _spender: indexed(address), _value: uint256
    end
  end



=begin
# Variables of the token.
name: public(bytes32)
symbol: public(bytes32)
totalSupply: public(uint256)
decimals: public(uint256)
balances: int128[address]
allowed: int128[address][address]
=end


=begin
@public
def __init__(_name: bytes32, _symbol: bytes32, _decimals: uint256, _initialSupply: uint256):

    self.name = _name
    self.symbol = _symbol
    self.decimals = _decimals
    self.totalSupply = uint256_mul(_initialSupply, uint256_exp(convert(10, 'uint256'), _decimals))
    self.balances[msg.sender] = convert(self.totalSupply, 'int128')
=end


  def initialize( name:, symbol:, decimals:, initial_supply: )
    @name     = name
    @symbol   = symbol
    @decimals = decimals
    @total_supply =  initial_supply * decimals ** 10 ##FIX   # uint256_mul(_initialSupply, uint256_exp(convert(10, 'uint256'), _decimals))
    @balances     = {}
    @balances[ msg.sender ] = @total_supply   ##FIX    ## self.balances[msg.sender] = convert(self.totalSupply, 'int128')
  end


=begin
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


# Transfer allowed tokens from a specific account to another.
@public
def transferFrom(_from: address, _to: address, _value: int128(uint256)) -> bool:

    assert _value <= self.allowed[_from][msg.sender]
    assert _value <= self.balances[_from]

    self.balances[_from] -= _value  # decrease balance of from address.
    self.allowed[_from][msg.sender] -= _value  # decrease allowance.
    self.balances[_to] += _value  # incease balance of to address.
    log.Transfer(_from, _to, convert(_value, 'uint256'))  # log transfer event.

    return True


# Allow _spender to withdraw from your account, multiple times, up to the _value amount.
# If this function is called again it overwrites the current allowance with _value.
#
# NOTE: We would like to prevent attack vectors like the one described here:
#       https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#heading=h.m9fhqynw2xvt
#       and discussed here:
#       https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
#
#       Clients SHOULD make sure to create user interfaces in such a way that they
#       set the allowance first to 0 before setting it to another value for the
#       same spender. THOUGH The contract itself shouldn't enforce it, to allow
#       backwards compatilibilty with contracts deployed before.
@public
def approve(_spender: address, _amount: int128(uint256)) -> bool:

    self.allowed[msg.sender][_spender] = _amount
    log.Approval(msg.sender, _spender, convert(_amount, 'uint256'))

    return True


# Get the allowance an address has to spend another's token.
@public
def allowance(_owner: address, _spender: address) -> uint256:

    return convert(self.allowed[_owner][_spender], 'uint256')
=end

end ## class Token


token = Token.new(
  name: 'Your Crypto Token', symbol: 'YOU', decimals: 8, initial_supply: 1_000_000
)


pp token
