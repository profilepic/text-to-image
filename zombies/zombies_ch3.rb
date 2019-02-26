#####################################################
# Zombie Helper Contract (incl. Zombie Feeding, Zombie Factory, Ownable)

# @sig (uint, string, uint)
NewZombie = Event.new(:zombie_id, :name, :dna)

DNA_DIGITS    = 16
DNA_MODULUS   = 10 ** DNA_DIGITS
COOLDOWN_TIME = 1.day


# @sig (string, uint, uint32, uint32)
Zombie = Struct.new( name:       '',
                     dna:        0,
                     level:      0;
                     ready_time: Timestamp(0) )

def setup
  @owner              = msg.sender
  @zombies            = Array.of( Zombie )
  @zombie_to_owner    = Mapping.of( Integer => Address )
  @owner_zombie_count = Mapping.of( Address => Integer )

  @kitty_contract     = KittyInterface(0)
end

# @sig (string, uint) private
def create_zombie( name, dna )
  zombie = Zombie.new( name, dna, 1, block.timestamp + COOLDOWN_TIME )
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


# @sig (address) external
def set_kitty_contract_address( address )
  assert @owner == msg.sender
  @kitty_contract = KittyInterface( address )
end

# @sig (Zombie storage) internal
def trigger_cooldown( zombie )
  zombie.ready_time = block.timestamp + COOLDOWN_TIME
end

# @sig (Zombie storage) internal view returns (bool)
def is_ready?( zombie )
  zombie.ready_time <= block.timestamp
end

# @sig (uint, uint, string) public
def feed_and_multiply( zombie_id, target_dna, species )
  assert msg.sender == @zombie_to_owner[zombie_id]
  my_zombie = @zombies[zombie_id]
  assert is_ready?( my_zombie )
  target_dna = target_dna % DNA_MODULUS
  new_dna = (my_zombie.dna + target_dna) / 2
  if sha256( species ) == sha256( "kitty" )
    new_dna = new_dna - new_dna % 100 + 99
  end
  create_zombie( "NoName", new_dna )
  trigger_cooldown( my_zombie )
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

# @sig (uint, uint) public
def feed_on_kitty( zombie_id, kitty_id )
  _,_,_,_,_,_,_,_,_, kitty_dna = @kitty_contract.get_kitty( kitty_id )
  feed_and_multiply( zombie_id, kitty_dna, "kitty" )
end


# @sig (uint, string) external
def change_name( zombie_id, new_name)
   assert @zombies[zombie_id].level >= 2
   assert msg.sender == @zombie_to_owner[zombie_id]
   @zombies[zombie_id].name = new_name
end

# @sig (uint, uint) external
def change_dna( zombie_id, new_dna)
  assert @zombies[zombie_id].level >= 20
  assert msg.sender == @zombie_to_wwner[zombie_id]
  @zombies[zombie_id].dna = new_dna
end

# @sig (address) external view returns (uint[])
def get_zombies_by_owner( owner )
  result = Array.of( Integer, @owner_zombie_count[owner] )
  counter = 0
  (0..@zombies.length).each do |i|
    if @zombie_to_owner[i] == owner
      result[counter] = i;
      counter += 1
    end
  end
  result
end
