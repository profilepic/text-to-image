
require_relative 'lib/universum'


require 'active_record'




class ActiveContract < Contract


  def self.at( addr )
    self.new( addr: addr )
  end


  def addr() @storage.addr; end


private
  def initialize( *args, **kwargs )
     puts "ActiveContract.initialize:"
     pp args
     pp kwargs

     super()   ## note: call super with NO args for now - todo/fix: change to kwargs too - why? why not?

     puts "hello from ActiveContract.initialize"

     if kwargs[:addr]
       ## try to restore/load state
       addr = kwargs[:addr]
       Connection.for( addr )

       @storage = self.class::Storage.find_by!( addr: addr )
     else
       ## else init state
       addr = "0x#{Time.now.to_i}#{rand(100)}"   ## use / hard-code '0x7777' - why? why not?
       Connection.for( addr )

       @storage = self.class::Storage.new
       @storage.addr = addr

       if kwargs.empty?
         on_create( *args )    ## change to on_init or ?? - why? why not?
       else
         if args.empty?
           on_create( kwargs )  ## allow (pass along) just kwargs
         else
           on_create( *args, kwargs )
         end
       end
       @storage.save   ## note: do NOT forget to save the state!!!
     end

     pp @storage
   end
end


class Connection   ## note: connection "manager" is a "dummy" for now

  def self.for( addr )
    @@con ||= {}
    c = @@con[addr]
    if c
      puts "+++++ storage ++++++++++++++++++++++++++++++++++++"
      puts "+++ reuse database connection for address #{addr}"
    else
      puts "+++++++ storage +++++++++++++++++++++++++++++++++++++++++++++++++"
      puts "+++ bingo! new address #{addr} - prepare new database (storage)"
      @@con[addr] = true
    end
  end

end  ## Connection




class GreeterStorage
  def self.up
    ActiveRecord::Schema.define do
      create_table :greeter_storages do |t|
        t.string  :addr,       null: false
        t.string  :greeting
      end
    end  # Schema.define
  end # method up
end # class


class Greeter < ActiveContract

  class Storage < ActiveRecord::Base
     self.table_name = 'greeter_storages'
  end


  def self.create( greeting )
    self.new( greeting )
  end

  def on_create( greeting )
    @storage.greeting = greeting
  end



  def greet
    @storage.greeting
  end
end # class Greeter




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



  class Storage < ActiveRecord::Base
     self.table_name = 'token_storages'
  end

  class Balance < ActiveRecord::Base
     self.table_name = 'token_balances'
  end

  class Allowance < ActiveRecord::Base
     self.table_name = 'token_allowances'
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
    b = Balance.new
    b.addr  = addr
    b.key   = msg.sender
    b.value = @storage.total_supply
    b.save
  end



  # What is the balance of a particular account?
  def balance_of( owner: )  ## (_owner: address) -> uint256:
    ##  note: will return 0 if not found (uses Hash.new(0) for 0 default)
    b = Balance.find_by( addr: addr, key: owner )
    b ? b.value : 0
  end


  # Send `_value` tokens to `_to` from your account
  def transfer( to:, value: )  ## (_to: address, _value: int128(uint256)) -> bool:
    puts "transfer to: >#{to}< value: >#{value}<"

    balance_from = Balance.find_or_initialize_by( addr: addr, key: msg.sender )
    balance_to   = Balance.find_or_initialize_by( addr: addr, key: to )

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

    balance_from   = Balance.find_or_initialize_by( addr: addr, key: from )
    balance_to     = Balance.find_or_initialize_by( addr: addr, key: to )
    allowance_from = Allowance.find_or_initialize_by( addr: addr, key1: from, key2: msg.sender )

    if value <= allowance_from.value &&
       value <= balance_from.value

      balance_from.value   -= value  # decrease balance of from address.
      allowance_from.value -= value  # decrease allowance.
      balance_to.value     += value  # incease balance of to address.

      balance_from.save
      allowance_from.save
      balance_to.save

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
    allowance = Allowance.find_or_initialize_by( addr: addr, key1: msg.sender, key2: spender )
    allowance.value = value
    allowance.save

    log Approval.new( owner: msg.sender, spender: spender, value: value )

    true
  end


  # Get the allowance an address has to spend another's token.
  def allowance( owner:, spender: )  ## _owner: address, _spender: address
    a = Allowance.find_by( addr: addr, key1: owner, key2: spender )
    a ? a.value : 0
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


GreeterStorage.up
TokenStorage.up


greeter = Greeter.create( 'Hello, World!' )
pp greeter

pp greeter.greet
pp greeter.addr

addr = greeter.addr   ## save addr(ess) for restore (state) from db

##################
## use/try send_transaction

greeter_de = Greeter.create( 'Hallo, Welt!' )
pp greeter_de
pp greeter_de.addr

pp greeter_de.send_transaction( :greet )


####
#  restore/resume greeter
greeter2 = Greeter.at( addr )
pp greeter2

pp greeter.greet
pp greeter.addr


#############
#  start testing tokens...

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

end
