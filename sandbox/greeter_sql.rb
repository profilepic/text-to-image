
require_relative '../lib/universum'


require 'active_record'




class ActiveContract < Contract

   class Storage < ActiveRecord::Base
   end


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
       @storage = Storage.find_by!( addr: kwargs[:addr] )
     else
       ## else init state
       @storage = Storage.new
       @storage.addr = "0x#{Time.now.to_i}"   ## use / hard-code '0x7777' - why? why not?

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



class GreeterStorage
  def self.up
    ActiveRecord::Schema.define do
      create_table :storages do |t|
        t.string  :addr,       null: false
        t.string  :greeting
      end
    end  # Schema.define
  end # method up
end # class


class  Greeter < ActiveContract

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




#############
#  start testing...

if __FILE__ == $0

ActiveRecord::Base.establish_connection( adapter:  'sqlite3',
                                         database: ':memory:' )
ActiveRecord::Base.logger = Logger.new( STDOUT )  ## turn on activerecord logging to console


GreeterStorage.up



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


end
