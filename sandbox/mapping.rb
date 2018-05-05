
require 'pp'


class Balance    ## dummy ActiveRecord stub for testing
  def self.find_or_initialize_by( **params )
     puts "calling Balance.find_or_initialize_by: "
     pp params
  end
end

class Allowance    ## dummy ActiveRecord stub for testing
  def self.find_or_initialize_by( **params )
     puts "calling Allowance.find_or_initialize_by: "
     pp params
  end
end


## helper convenience "proxy" for array-like access for mappings

class BalanceMapping
  def initialize( **params )
     @params = params
  end
  def [](key)
    ## e.g. find by addr:,key:
    Balance.find_or_initialize_by( @params.merge( key: key ) )
  end
end  ## class BalanceMapping


class AllowanceMapping
  class InnerMapping
    def initialize( **params )
      @params = params
    end
    def [](key)
      ## e.g. find by addr:,key:
      Allowance.find_or_initialize_by( @params.merge( key2: key ) )
    end
  end # class InnerMapping

  def initialize( **params )
     @params = params
  end
  def [](key)
    InnerMapping.new( @params.merge( key1: key ) )
  end
end  ## class AllowanceMapping




balances = BalanceMapping.new( addr: '0x1111' )
balances[ '0x2222' ]

allowances = AllowanceMapping.new( addr: '0x1111' )
allowances[ '0x2222' ][ '0x3333' ]


################################################
#### try out build mapping from "template"


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
        else    ## note: allow "nested" mappings; assume "nested" mapping
          klass.new( @params.merge( k => key ) )
        end
      end
    end
  end
end # class Mapping



puts "============================="
puts "testing dyna mappings:"

TestBalanceMapping = Mapping.create( Balance, :key )
pp TestBalanceMapping
balances = TestBalanceMapping.new( addr: '0x1111' )
balances[ '0x2222' ]


TestAllowanceMapping = Mapping.create( Mapping.create( Allowance, :key2 ), :key1 )
pp TestAllowanceMapping
allowances = TestAllowanceMapping.new( addr: '0x1111' )
allowances[ '0x2222' ][ '0x3333' ]
