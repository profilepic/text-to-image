## our own "3rd" party gems
require 'artfactory/base'



## our own code
require_relative 'cyberpunks/version'    # note: let version always go first



###
## add convenience pre-configurated generatored with build-in spritesheet (see config)
module Cyberpunk
  class Spritesheet
    def self.builtin
      @builtin ||= Pixelart::Spritesheet.read(  "#{Pixelart::Module::Cyberpunks.root}/config/spritesheet.png",
                                                "#{Pixelart::Module::Cyberpunks.root}/config/spritesheet.csv",
                                                 width:  32,
                                                 height: 32 )
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
      @generator ||= Artfactory.use(  Cyberpunk::Sheet.builtin,
                                      image_class: Image )
    end


    NAMES = ['cyberpunk', 'cyberpunks']

    DEFAULT_ATTRIBUTES = ['Human 9',
     'Smile',
     'Delicate',
     'Femme Wide',
     'Large Hoop Earrings',
     'Messy Bun']

    def self.generate( *names )
       generator.generate( *names )
    end
  end # class Image
end #  module Cyberpunk


### add some convenience shortcuts
CyberPunk  = Cyberpunk




###
# note: for convenience auto include Pixelart namespace!!! - why? why not?
include Pixelart



puts Pixelart::Module::Cyberpunks.banner    # say hello
