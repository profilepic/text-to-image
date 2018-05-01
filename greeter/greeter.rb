##########
#  adapted ruby version (for universum)
#
#  Create a digital greeter
#    see https://www.ethereum.org/greeter
#
#  to test the contract script run:
#   $ ruby greeter/greeter.rb


require_relative '../lib/universum'


class Mortal < Contract

  def initialize
    @owner = msg.sender
  end

  ## Function to recover the funds on the contract
  def kill
    destroy( @owner )  if msg.sender == @owner
  end
end # class Mortal


class  Greeter < Mortal

  def initialize( greeting )
    super()   # note: must call super on base class; NOT auto-magic
    @greeting = greeting
  end

  def greet
    @greeting
  end
end # class Greeter



#############
#  start testing...

if __FILE__ == $0

greeter = Greeter.new( 'Hello, World!' )
pp greeter

pp greeter.greet
pp greeter.kill


##################
## use/try send_transaction

greeter_de = Greeter.new( 'Hallo, Welt!' )

pp greeter_de.send_transaction( :greet )
pp greeter_de.send_transaction( :kill )

end
