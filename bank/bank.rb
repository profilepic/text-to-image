# adapedted ruby version (for universum)
# simple bank example from learn x in y
#   see https://learnxinyminutes.com/docs/solidity
##
# a simple bank contract
#  allows deposits, withdrawals, and balance checks
#
#
#  to test the contract script run:
#   $ ruby bank/bank.rb



require_relative '../lib/universum'



class Bank < Contract

  class DepositMade < Event
    def initialize( address, amount )
      @address, @amount = address, amount
    end
  end # class DespositMade


  def initialize
    @owner    = msg.sender
    @balances = Hash.new(0)   ## note: special hash (default value is 0 and NOT nil)
  end


  #  Deposit money into bank
  #    return the balance of the user after the deposit is made

  def deposit    ## public payable returns (uint)
    ## Here we are making sure that there isn't an overflow issue
    assert @balances[msg.sender] + msg.value >= balances[msg.sender]

    @balances[msg.sender] += msg.value

    log DepositMade.new( msg.sender, msg.value )

    @balances[msg.sender]
  end

  #  Withdraw money from bank
  #    withdrawAmount => amount you want to withdraw
  #    return the balance remaining for the user
  #   Note: This does not return any excess money sent to it

  def withdraw(amount)   ## (uint withdrawAmount) public returns (uint remainingBal)
    assert amount <= @balances[msg.sender]

    @balances[msg.sender] -= amount

    ## this automatically throws on a failure,
    ##  which means the updated balance is reverted
    msg.sender.transfer( amount)

    @balances[msg.sender]
  end


  #  Get balance
  #   return the balance of the user
  def balance
    @balances[msg.sender]
  end

end # class Bank
