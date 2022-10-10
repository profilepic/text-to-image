## our own "3rd" party gems
require 'artfactory/base'



## our own code
require_relative 'nouns/version'    # note: let version always go first



module Noun

  class Spritesheet

    def self.builtin    ### check: use a different name e.g. default,standard,base or such - why? why not?
      @sheet ||= Pixelart::Spritesheet.read( "#{Pixelart::Module::Nouns.root}/config/spritesheet.png",
                                             "#{Pixelart::Module::Nouns.root}/config/spritesheet.csv",
                                              width:  32,
                                              height: 32 )
    end

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
      @generator ||= Artfactory.use(  Noun::Sheet.builtin,
                                      image_class: Image )
    end


    NAMES = ['noun', 'nouns']
    DEFAULT_ATTRIBUTES = ['Body Grayscale 1',
                          'Checker Bigwalk Rainbow',
                          'Head Beer',
                          'Glasses Square Fullblack']

    def self.generate( *names )
       generator.generate( *names )
     end # method Image.generate
  end # class Image
end #  module Noun




###
# note: for convenience auto include Pixelart namespace!!! - why? why not?
include Pixelart



puts Pixelart::Module::Nouns.banner    # say hello
