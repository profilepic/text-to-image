#  to test the contract script run:
#   $ ruby tokens/token_test.rb


require 'minitest/autorun'


require_relative 'token'

class TestToken < Minitest::Test

  def setup
    @token = Token.new(
      name:          'Your Crypto Token',
      symbol:        'YOU',
      decimals:       8,
      initial_supply: 1_000_000
    )
  end

  def test_transfer
    assert_equal 100_000_000_000_000, @token.balance_of( owner: '0x0000' )
    assert_equal 0,                   @token.balance_of( owner: '0x1111' )

    assert @token.transfer( to: '0x1111', value: 100 )
    assert_equal 100, @token.balance_of( owner: '0x1111' )

    assert @token.transfer( to: '0x2222', value: 200 )
    assert_equal 200, @token.balance_of( owner: '0x2222' )

    assert_equal 99_999_999_999_700, @token.balance_of( owner: '0x0000' )
  end


  def test_transfer_from

    ## note: NOT pre-approved (no allowance) - will FAIL
    assert !@token.transfer_from( from: '0x1111', to: '03333', value: 30 )
    assert_equal 0, @token.allowance( owner: '0x0000', spender: '0x1111' )

    assert @token.approve( spender: '0x1111', value: 50 )
    assert_equal 50, @token.allowance( owner: '0x0000', spender: '0x1111' )

    ### change sender to 0x0001
    Contract.msg = { sender: '0x1111' }
    pp Contract.msg

    assert @token.transfer_from( from: '0x0000', to: '0x3333', value: 30 )
    assert_equal 30,                 @token.balance_of( owner: '0x3333' )
    assert_equal 99_999_999_999_970, @token.balance_of( owner: '0x0000' )
    assert_equal 0,                  @token.balance_of( owner: '0x1111' )

    ### change sender back to 0x0000
    Contract.msg = { sender: '0x0000' }
    pp Contract.msg

    assert @token.transfer( to: '0x1111', value: 1 )
    assert_equal 99_999_999_999_969, @token.balance_of( owner: '0x0000' )
    assert_equal 1,                  @token.balance_of( owner: '0x1111' )
  end

end # class TestToken
