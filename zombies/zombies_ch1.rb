##############################################
# Zombie Factory Contract

# @sig (uint, string, uint)
NewZombie = Event.new(:zombie_id, :name, :dna)

DNA_DIGITS  = 16
DNA_MODULUS = 10 ** DNA_DIGITS

Zombie = Struct.new( name: '', dna: 0 )

def setup
  @zombies = Array.of( Zombie )
end

# @sig (string, uint) private
def create_zombie( name, dna )
  id = @zombies.push( Zombie.new( name, dna)) - 1
  log NewZombie.new( id, name, dna )
end

# @sig (string) private view returns (uint) 
def generate_random_dna( str )
  rand = hex_to_i( sha256( str ) )
  rand % DNA_MODULUS
end

# @sig (string) public
def create_random_zombie( name ) 
  rand_dna = generate_random_dna( name )
  create_zombie( name, rand_dna )
end
