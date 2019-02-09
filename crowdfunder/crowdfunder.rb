##############################
# Crowd Funder Contract

State = Enum.new( :fundraising, :expired_refund, :successful )

Contribution = Struct.new( :amount, :contributor )

FundingReceived = Event.new( :address, :amount, :current_total )
WinnerPaid      = Event.new( :winner_address )


def initialize(
      time_in_hours_for_fundraising,
      campaign_url,
      fund_recipient,
      minimum_to_raise )

  @creator          = msg.sender
  @fund_recipient   = fund_recipient   # note: creator may be different than recipient
  @campaign_url     = campaign_url
  @minimum_to_raise = minimum_to_raise # required to tip, else everyone gets refund
  @raise_by         = block.timestamp + (time_in_hours_for_fundraising * 1.hour )

  @state            = State.fundraising
  @total_raised     = 0
  @complete_at      = 0
  @contributions    = Array.of( Contribution )
end



def pay_out
  assert @state.successful?

  @fund_recipient.transfer( this.balance )
  log WinnerPaid.new( @fund_recipient )
end

def check_if_funding_complete_or_expired
  if @total_raised > @minimum_to_raise
    @state = State.successful
    pay_out()
  elsif block.timestamp > @raise_by
    # note: backers can now collect refunds by calling refund(id)
    @state = State.expired_refund
    @complete_at = block.timestamp
  end
end


def contribute
  assert @state.fundraising?

  @contributions.push( Contribution.new( msg.value, msg.sender ))
  @total_raised += msg.value

  log FundingReceived.new( msg.sender, msg.value, @total_raised )

  check_if_funding_complete_or_expired()

  @contributions.size - 1   # return (contribution) id
end


def refund( id )
  assert @state.expired_refund?
  assert @contributions.size > id && id >= 0 && @contributions[id].amount != 0

  amount_to_refund = @contributions[id].amount
  @contributions[id].amount = 0

  @contributions[id].contributor.transfer( amount_to_refund )

  true
end

def kill
  assert msg.sender == @creator
  # wait 24 weeks after final contract state before allowing contract destruction
  assert (state.expired_refund? || state.successful?) && @complete_at + 24.weeks < block.timestamp

  # note: creator gets all money that hasn't be claimed
  selfdestruct( msg.sender )
end
