## our own "3rd" party gems
require 'artfactory/base'



## our own code
require_relative 'goblins/version'    # note: let version always go first



module Goblin

  class Spritesheet
    def self.builtin
      @builtin ||= Pixelart::Spritesheet.read(  "#{Pixelart::Module::Goblins.root}/config/spritesheet-24x24.png",
                                                "#{Pixelart::Module::Goblins.root}/config/spritesheet-24x24.csv",
                                                 width:  24,
                                                 height: 24 )
    end
    ## note: for now class used for "namespace" only
    def self.find_by( name: )  ## return archetype/attribute image by name
       builtin.find_by( name: name )
    end
  end  # class Spritesheet
  ## add convenience (alternate spelling) alias - why? why not?
  SpriteSheet = Spritesheet
  Sheet       = Spritesheet
  Sprite      = Spritesheet


  class Image < Pixelart::Image

    def self.generator
      @generator ||= Artfactory.use(  Goblin::Sheet.builtin,
                                      image_class: Image )
    end

    NAMES = ['goblin', 'goblins', 'goblinz']

    DEFAULT_ATTRIBUTES = ['Green', 'Teeth',
                          '3D Glasses', 'Blue Sweater']

    def self.generate( *names )
       generator.generate( *names )
     end # method Image.generate
  end # class Image
end #  module Goblin




module Lilgoblin

  class Spritesheet
    def self.builtin
      @builtin ||= Pixelart::Spritesheet.read(  "#{Pixelart::Module::Goblins.root}/config/spritesheet-20x20.png",
                                                "#{Pixelart::Module::Goblins.root}/config/spritesheet-20x20.csv",
                                                 width:  20,
                                                 height: 20 )
    end
    ## note: for now class used for "namespace" only
    def self.find_by( name: )  ## return archetype/attribute image by name
       builtin.find_by( name: name )
    end
  end  # class Spritesheet
  ## add convenience (alternate spelling) alias - why? why not?
  SpriteSheet = Spritesheet
  Sheet       = Spritesheet
  Sprite      = Spritesheet



  class Image < Pixelart::Image
    def self.generator
      @generator ||= Artfactory.use(  Lilgoblin::Sheet.builtin,
                                      image_class: Image )
    end


    NAMES = ['lilgoblin', 'lilgoblins', 'lilgoblinz']

    DEFAULT_ATTRIBUTES = ['Green', 'Orange Beanie',
                          'Earring Silver', 'Blue Sweater']

    def self.generate( *names )
       generator.generate(  *names )
     end # method Image.generate
  end # class Image
end #  module Lilgoblin


### add some convenience shortcuts
LilGoblin  = Lilgoblin




###
# note: for convenience auto include Pixelart namespace!!! - why? why not?
include Pixelart



puts Pixelart::Module::Goblins.banner    # say hello
