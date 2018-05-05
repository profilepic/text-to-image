#########################################
#  to test the contract script run:
#   $ ruby tokens/token_sql.rb


require_relative '../lib/universum'



class TokenStorage
  ###############################
  # Variables of the token
  #  name:        public(bytes32)
  #  symbol:      public(bytes32)
  #  totalSupply: public(uint256)
  #  decimals:    public(uint256)
  #  balances:    int128[address]
  #  allowed:     int128[address][address]

  def self.up
    ActiveRecord::Schema.define do
      create_table :token_storages do |t|
        t.string  :addr,       null: false   ## use __addr__ for internal address - why? why not?
        t.string  :name
        t.string  :symbol
        t.integer :decimals
        t.integer :total_supply,  :limit => 8  ## check for bigint!!!
      end

     create_table :token_balances do |t|
        t.string  :addr,   null: false
        t.string  :key,    null: false
        t.integer :value,  null: false, default: 0, :limit => 8  ## check for bigint!!!
     end

     create_table :token_allowances do |t|
        t.string  :addr,   null: false
        t.string  :key1,   null: false
        t.string  :key2,   null: false
        t.integer :value,  null: false, default: 0, :limit => 8  ## check for bigint!!!
     end
    end  # Schema.define
  end # method up
end # class



class Token < ActiveContract

  ############################
  # Events of the token
  #  Transfer: event({_from: indexed(address), _to: indexed(address), _value: uint256})
  #  Approval: event({_owner: indexed(address), _spender: indexed(address), _value: uint256})

  class Transfer < Event
    def initialize( from:, to:, value: )
      @from, @to, @value  = from, to, value
    end
  end

  class Approval < Event
    def initialize( owner:, spender:, value: )
      @owner, @spender, @value = owner, spender, value
    end
  end


  ####################################
  # Storage (a.k.a. SQL Database)

  class Balance < ActiveRecord::Base
     self.table_name = 'token_balances'
  end

  class Allowance < ActiveRecord::Base
     self.table_name = 'token_allowances'
  end

  # use "convenience" helpers for array-like (e.g. []) access to mappings
  BalanceMapping   = Mapping.create( Balance, :key )
  AllowanceMapping = Mapping.create( Mapping.create( Allowance, :key2 ), :key1 )

  class Storage < ActiveRecord::Base
     self.table_name = 'token_storages'

     def balances()    BalanceMapping.new( addr: addr ); end
     def allowances()  AllowanceMapping.new( addr: addr ); end
  end



  def self.create( name:, symbol:, decimals:, initial_supply: )
    self.new( name, symbol, decimals, initial_supply )
  end

  def on_create( name, symbol, decimals, initial_supply )  ## _name: bytes32, _symbol: bytes32, _decimals: uint256, _initialSupply: uint256
    @storage.name     = name
    @storage.symbol   = symbol
    @storage.decimals = decimals
    @storage.total_supply =  initial_supply * (10 ** decimals)

    ##  @balances[msg.sender]  =  @storage.total_supply
    b       = @storage.balances[ msg.sender ]
    b.value = @storage.total_supply
    b.save
  end



  # What is the balance of a particular account?
  def balance_of( owner: )  ## (_owner: address) -> uint256:
    ##  note: will return 0 if not found (uses Hash.new(0) for 0 default)
    @storage.balances[ owner ].value
  end


  # Send `_value` tokens to `_to` from your account
  def transfer( to:, value: )  ## (_to: address, _value: int128(uint256)) -> bool:
    puts "transfer to: >#{to}< value: >#{value}<"

    balance_from = @storage.balances[ msg.sender ]
    balance_to   = @storage.balances[ to ]

    if balance_from.value >= value &&
       balance_to.value + value >= balance_to.value

      balance_from.value -= value  # Subtract from the sender
      balance_to.value += value  # Add the same to the recipient

      balance_from.save
      balance_to.save

      log Transfer.new( from: msg.sender, to: to, value: value )   # log transfer event.

      true
    else
      false
    end
  end


  # Transfer allowed tokens from a specific account to another.
  def transfer_from( from:, to:, value: ) ###(_from: address, _to: address, _value: int128(uint256)) -> bool:

    balance_from   = @storage.balances[ from ]
    balance_to     = @storage.balances[ to ]
    allowance_from = @storage.allowances[ from ][ msg.sender ]

    if value <= allowance_from.value &&
       value <= balance_from.value

      balance_from.value   -= value  # decrease balance of from address.
      allowance_from.value -= value  # decrease allowance.
      balance_to.value     += value  # incease balance of to address.

      balance_from.save
      balance_to.save
      allowance_from.save

      log Transfer.new( from: from, to: to, value: value )   # log transfer event.

      true
    else
      false
    end
  end

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

  def approve( spender:, value: )   ##(_spender: address, _value: int128(uint256)) -> bool:
    allowance = @storage.allowances[ msg.sender ][ spender ]
    allowance.value = value
    allowance.save

    log Approval.new( owner: msg.sender, spender: spender, value: value )

    true
  end


  # Get the allowance an address has to spend another's token.
  def allowance( owner:, spender: )  ## _owner: address, _spender: address
    @storage.allowances[ owner ][ spender ].value
  end

end ## class Token





#############
#  start testing...

if __FILE__ == $0

###
## todo/fix - future:
##  every contract gets an new database!!!
##   check multiple in-memory database possible too with activerecord????


ActiveRecord::Base.establish_connection( adapter:  'sqlite3',
                                         database: ':memory:' )
ActiveRecord::Base.logger = Logger.new( STDOUT )  ## turn on activerecord logging to console


TokenStorage.up



## sample event handler
class EventHandler
  def handle( event )
     puts "new event:"
     pp event
  end
end

Contract.handlers << EventHandler.new

## Contract.msg = Contract::Msg.new( sender: '0x0000' )
## pp Contract.msg


token = Token.create(
  name:          'Your Crypto Token',
  symbol:        'YOU',
  decimals:       8,
  initial_supply: 1_000_000
)

pp token
pp token.addr


pp token.balance_of( owner: '0x0000' )
pp token.balance_of( owner: '0x1111' )

pp token.transfer( to: '0x1111', value: 100 )
pp token.balance_of( owner: '0x1111' )

pp token.transfer( to: '0x2222', value: 200 )
pp token.balance_of( owner: '0x2222' )


## note: NOT pre-approved (no allowance) - will FAIL
pp token.transfer_from( from: '0x1111', to: '03333', value: 30 )
pp token.allowance( owner: '0x0000', spender: '0x1111' )

pp token.approve( spender: '0x1111', value: 50 )
pp token.allowance( owner: '0x1111', spender: '0x0000' )


### change sender to 0x1111
Contract.msg = { sender: '0x1111' }
pp Contract.msg
## pp Contract.msg = Contract::Msg.new( sender: '0x0001' )

pp token.transfer_from( from: '0x0000', to: '0x3333', value: 30 )
## pp token.transfer( to: '0x0000', value: 1 )
pp token.balance_of( owner: '0x3333' )
pp token.balance_of( owner: '0x0000' )
pp token.balance_of( owner: '0x1111' )


### change sender back to 0x0000
Contract.msg = { sender: '0x0000' }
pp Contract.msg

pp token.transfer( to: '0x1111', value: 1 )
pp token.balance_of( owner: '0x0000' )
pp token.balance_of( owner: '0x1111' )


#####################################
## use sent_transaction style
pp token.send_transaction( :balance_of, owner: '0x0000' )
pp token.send_transaction( :balance_of, owner: '0x1111' )

pp token.send_transaction( :transfer, to: '0x1111', value: 100 )
pp token.send_transaction( :balance_of, owner: '0x1111' )

pp token.send_transaction( :transfer, to: '0x2222', value: 200 )
pp token.send_transaction( :balance_of, owner: '0x2222' )


end
