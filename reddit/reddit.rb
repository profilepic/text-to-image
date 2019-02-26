#################################
# Decentralized Reddit Contract
#
#  see "Building a decentralized Reddit" (for the original version in Solidity)
#   @ https://embark.status.im/news/2019/02/04/building-a-decentralized-reddit-with-embark-part-1/


Ballot = Enum.new( :none, :upvote, :downvote )

Post = Struct.new(
    creation_date: Timestamp(0),
    description:   '',
    owner:         Address(0),
    upvotes:       0,
    downvotes:     0,
    votes:         Mapping.of( Address => Ballot )
)

NewPost  = Event.new( :post_id, :owner, :description )
NewVote  = Event.new( :post_id, :owner, :vote )


def setup
  @posts = Array.of( Post )
end

def create_post( description )
  post = Post.new(
              block.timestamp,
               description,
               msg.sender,
               0,
               0 )
  post_id = @posts.push( post ) - 1

  log NewPost( post_id, msg.sender, description )
end

def vote( post_id, vote )
  post = @posts[ post_id ]

  assert post.creation_date != 0, "Post does not exist"
  assert post.voters[msg.sender] == Ballot.none, "You already voted on this post"

  ballot = Ballot(vote)

  if ballot.upvote?
    post.upvotes   += 1
  else
    post.downvotes += 1
  end

  post.voters[msg.sender] = ballot
  log NewVote( post_id, msg.sender, vote )
end

def can_vote?( post_id )
  if post_id > posts.length - 1
     return false
  end

  post = @posts[post_id]
  post.voters[msg.sender] == Ballot.none
end

def get_vote( post_id )
  post = @posts[ post_id ]
  post.voters[msg.sender]
end

def num_posts
  @posts.length
end
