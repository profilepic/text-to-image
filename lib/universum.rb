
## stdlibs
require 'pp'    ## pretty print (pp)


## 3rd party libs / gems
require 'active_record'


class Contract
  class Event; end   ## base class for events

  ## blockchain message (msg) context
  ##   includes:  sender (address)
  ##  todo: allow writable attribues e.g. sender - why? why not?
  class Msg
    attr_reader :sender

    def initialize( sender: '0x0000' )
      @sender = sender
    end
  end  # class Msg


  def self.msg
      @@msg ||= Msg.new
  end

  def self.msg=( value )
    if value.is_a? Hash
      kwargs = value
      @@msg = Msg.new( kwargs )
    else   ## assume Msg class/type
      @@msg = value
    end
  end

  def msg() self.class.msg; end


  def self.handlers    ## use listeners/observers/subscribers/... - why? why not?
    @@handlers ||= []
  end


  def self.log( event )
    handlers.each { |h| h.handle( event ) }
  end

  def log( event ) self.class.log( event ); end


  def assert( cond )
    cond == true ? true : false
  end

  def destroy( owner )   ## todo/check: use a different name e.g. destruct/ delete - why? why not?
     ## selfdestruct function (for clean-up on blockchain)
     ## fix: does nothing for now - add some code (e.g. cleanup)
     ##  mark as destruct - why? why not?
  end

  def send_transaction( method, *args )
      __send__( method, *args )   ## note: use __send__ (instead of send - might be overriden)
      ## todo/fix: add send_tx alias - why? why not?
  end


end  # class Contract




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



#########################
## helper convenience "proxy" for array-like access for mappings
## e.g.
##
##  BalanceMapping = Mapping.create( Balance, :key )
##  balances = BalanceMapping.new( addr: '0x1111' )
##  balances[ '0x2222' ]
##
##  AllowanceMapping = Mapping.create( Mapping.create( Allowance, :key2 ), :key1 )
##  allowances = AllowanceMapping.new( addr: '0x1111' )
##  allowances[ '0x2222' ][ '0x3333' ]


class Mapping
  def self.create( klass, k )
    Class.new do
      define_method :initialize do |params|
         @params = params
      end

      define_method :'[]' do |key|
        ## e.g. find by addr:,key:
        puts "  Mapping for >#{klass.name}< []"
        if klass.respond_to? :find_or_initialize_by   ## assume ActiveRecord
          klass.find_or_initialize_by( @params.merge( k => key ) )
        else    ## assume "nested" mapping; yes, allow "nested / multi-dimension" mappings
          klass.new( @params.merge( k => key ) )
        end
      end
    end
  end
end # class Mapping
