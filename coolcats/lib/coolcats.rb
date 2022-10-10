## our own "3rd" party gems
require 'artfactory/base'



## our own code
require_relative 'coolcats/version'    # note: let version always go first



module Coolcat


  class Spritesheet
    def self.builtin    ### check: use a different name e.g. default,standard,base or such - why? why not?
      @sheet ||= Pixelart::Spritesheet.read( "#{Pixelart::Module::Coolcats.root}/config/spritesheet.png",
                                             "#{Pixelart::Module::Coolcats.root}/config/spritesheet.csv",
                                              width:  24,
                                              height: 24 )
    end

    def self.find_by( name: )  ## return archetype/attribute image by name
       builtin.find_by( name: name )
    end
  end  # class Spritesheet
  ## add convenience (alternate spelling) alias - why? why not?
  SpriteSheet = Spritesheet
  Sheet       = Spritesheet
  Sprite      = Spritesheet



  class Image  < Pixelart::Image


    def self.generator
      @generator ||= Artfactory.use(  Coolcat::Sheet.builtin,
                                      image_class: Image )
    end


    NAMES = ['coolcat', 'coolcats']

    DEFAULT_ATTRIBUTES = ['Happy']

    def self.generate( *names )
      ## note: always auto-add base coolcat archetye by default
       generator.generate( 'Base', *names )
     end # method Image.generate
  end # class Image

end #  module Coolcat



### add some convenience shortcuts
CoolCat  = Coolcat




###
# note: for convenience auto include Pixelart namespace!!! - why? why not?
include Pixelart



puts Pixelart::Module::Coolcats.banner    # say hello
