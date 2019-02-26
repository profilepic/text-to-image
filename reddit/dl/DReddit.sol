pragma solidity ^0.5.0;

contract DReddit {

  enum Ballot { NONE, UPVOTE, DOWNVOTE }

  struct Post {
    uint creationDate;   
    bytes description;   
    address owner;
    uint upvotes;
    uint downvotes;
    mapping(address => Ballot) voters;
  }

  Post [] public posts;

  event NewPost(
    uint indexed postId,
    address owner,
    bytes description
  );

  event NewVote(
    uint indexed postId,
    address owner,
    uint8 vote
  );

  function createPost(bytes memory _description) public {
    uint postId = posts.length++;

    posts[postId] = Post({
      creationDate: block.timestamp,
      description: _description,
      owner: msg.sender,
      upvotes: 0,
      downvotes: 0
    });

    emit NewPost(postId, msg.sender, _description);
  }

  function vote(uint _postId, uint8 _vote) public {
    Post storage post = posts[_postId];

    require(post.creationDate != 0, "Post does not exist");
    require(post.voters[msg.sender] == Ballot.NONE, "You already voted on this post");

    Ballot ballot = Ballot(_vote);

    if (ballot == Ballot.UPVOTE) {
        post.upvotes++;
    } else {
        post.downvotes++;
    }

    post.voters[msg.sender] = ballot;
    emit NewVote(_postId, msg.sender, _vote);
  }

  function canVote(uint _postId) public view returns (bool) {
    if (_postId > posts.length - 1) return false;
    Post storage post = posts[_postId];
    return (post.voters[msg.sender] == Ballot.NONE);
  }

  function getVote(uint _postId) public view returns (uint8) {
    Post storage post = posts[_postId];
    return uint8(post.voters[msg.sender]);
  }

  function numPosts() public view returns (uint) {
    return posts.length;
  }
}
