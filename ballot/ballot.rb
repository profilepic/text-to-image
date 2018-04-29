## adapted ruby version (for universum)
#
#  to test the contract script run:
#   $ ruby ballot/ballot.rb


require_relative '../lib/universum'


class Ballot < Contract

  ########################
  # structs

  class Voter
    attr_accessor :weight, :voted, :vote, :delegate

    def initialize( weight: 0, voted: false, vote: nil, delegate: nil )  ## uint weight; bool voted; uint8 vote; address delegate;
      @weight, @voted, @vote, @delegate = weight, voted, vote, delegate
    end
  end # class Voter

  class Proposal
    attr_accessor :vote_count

    def initialize( vote_count: 0 )  ## uint voteCount
      @vote_count = vote_count
    end
  end # class Proposal



  ## helper hash/mapping; auto-inits/adds record/mapping on (first) lookup
  class VoterHash
    def initialize()   @h = {}; end
    def [](addr)       @h[addr] ||= Voter.new; end
  end


  ## Create a new ballot with $(_numProposals) different proposals.
  def initialize( num_proposals )  ## uint8 _numProposals)
    @chairperson = msg.sender

    @voters = VoterHash.new
    @voters[@chairperson].weight = 1

    @proposals = []
    num_proposals.times { @proposals << Proposal.new }
  end


  ## Give $(toVoter) the right to vote on this ballot.
  ## May only be called by $(chairperson).
  def give_right_to_vote( to_voter: )   ## address toVoter
    return if msg.sender != @chairperson ||  @voters[to_voter].voted

    @voters[to_voter].weight = 1
  end



  ## Delegate your vote to the voter $(to).
  def delegate( to: ) ## address to
    sender = @voters[msg.sender]
    return if sender.voted

    ### todo/fix:
    ##  check add address to Contract base
    ##    address(0) !!!
    ##   address(0) is nil / empty address ????

    while @voters[to].delegate != nil &&
          @voters[to].delegate != msg.sender
      to = @voters[to].delegate
    end

    return if to == msg.sender

    sender.voted    = true
    sender.delegate = to

    delegate_to = @voters[to]
    if delegate_to.voted
      ## note/fix/bug!! - delegate_to.vote must reference a proposal 0..n  (defaults to nil!!!)
      ##   default to 0 - why? why not?
      @proposals[delegate_to.vote].vote_count += sender.weight   if delegate_to.vote
    else
      delegate_to.weight += sender.weight
    end
  end


  ## Give a single vote to proposal $(toProposal).
  def vote( to_proposal: )  ## uint8 toProposal
    sender = @voters[msg.sender]

    return if sender.voted || to_proposal >= @proposals.size

    sender.voted = true
    sender.vote  = to_proposal
    @proposals[to_proposal].vote_count += sender.weight
  end


  def winning_proposal  ## returns (uint8 _winningProposal)
    win_vote_count = 0
    win_proposal   = nil

    @proposals.each do |proposal|
      if proposal.vote_count > win_vote_count
        win_vote_count = proposal.vote_count
        win_proposal   = proposal
      end
    end

    win_proposal
  end

end #class Ballot



#############
#  start testing...

if __FILE__ == $0

ballot = Ballot.new( 3 )
pp ballot

ballot.give_right_to_vote( to_voter: '0x1111' )
ballot.give_right_to_vote( to_voter: '0x2222' )
pp ballot

Contract.msg = { sender: '0x1111' }  ### change sender to 0x1111
ballot.delegate( to: '0x2222' ) ## address to
pp ballot

Contract.msg = { sender: '0x0000' }  ### change sender back to 0x0000
ballot.vote( to_proposal: 0 )
pp ballot

Contract.msg = { sender: '0x2222' }  ### change sender to 0x2222
ballot.vote( to_proposal: 2 )
pp ballot

Contract.msg = { sender: '0x0000' }  ### change sender back to 0x0000

pp ballot.winning_proposal


end
