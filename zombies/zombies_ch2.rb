#####################################################
# Zombie Feeding Contract (incl. Zombie Factory)

# @sig (uint, string, uint)
NewZombie = Event.new(:zombie_id, :name, :dna)

DNA_DIGITS  = 16
DNA_MODULUS = 10 ** DNA_DIGITS

# @sig (string, uint)
Zombie = Struct.new( name: '', dna: 0 )

def setup
  @zombies            = Array.of( Zombie )
  @zombie_to_owner    = Mapping.of( Integer => Address )
  @owner_zombie_count = Mapping.of( Address => Integer )

  @kitty_contract     = KittyInterface( 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d )
end

# @sig (string, uint) private
def create_zombie( name, dna )
  zombie = Zombie.new( name, dna )
  id = @zombies.push( zombie ) - 1
  @zombie_to_owner[id] = msg.sender
  @owner_zombie_count[msg.sender] += 1

  log NewZombie.new( id, name, dna )
end

# @sig (string) private view returns (uint)
def generate_random_dna( str )
  rand = hex_to_i( sha256( str ) )
  rand % DNA_MODULUS
end


# @sig (string) public
def create_random_zombie( name )
  assert @owner_zombie_count[msg.sender] == 0
  rand_dna = generate_random_dna( name )
  rand_dna = rand_dna - rand_dna % 100
  create_zombie( name, rand_dna )
end


# @sig( uint, uint, string)
def feed_and_multiply( zombie_id, target_dna, species )
  assert msg.sender == @zombie_to_owner[zombie_id]
  my_zombie = @zombies[zombie_id]
  target_dna = target_dna % DNA_MODULUS
  new_dna = (my_zombie.dna + target_dna) / 2
  if sha256( species ) == sha256( "kitty" )
    new_dna = new_dna - new_dna % 100 + 99
  end
  create_zombie( "NoName", new_dna )
end

##
## contract KittyInterface {
##  function getKitty(uint256 _id) external view returns (
##    bool isGestating,
##    bool isReady,
##    uint256 cooldownIndex,
##    uint256 nextActionAt,
##    uint256 siringWithId,
##    uint256 birthTime,
##    uint256 matronId,
##    uint256 sireId,
##    uint256 generation,
##    uint256 genes
##  );
## }

# @sig (uint, uint)
def feed_on_kitty( zombie_id, kitty_id )
  _,_,_,_,_,_,_,_,_, kitty_dna = @kitty_contract.get_kitty( kitty_id )
  feed_and_multiply( zombie_id, kitty_dna, "kitty" )
end
