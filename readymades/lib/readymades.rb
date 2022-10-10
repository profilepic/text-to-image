## our own "3rd" party gems
require 'punks'     ### todo - add/change to punks/base !!!


## our own code
require_relative 'readymades/version'    # note: let version always go first




module Readymade

  class Spritesheet       ## note: for now class used for "namespace" only
    def self.builtin    ### check: use a different name e.g. default,standard,base or such - why? why not?
      @sheet ||= Pixelart::Spritesheet.read( "#{Pixelart::Module::Readymades.root}/config/spritesheet.png",
                                             "#{Pixelart::Module::Readymades.root}/config/spritesheet.csv",
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



  class Image < Pixelart::Image

    NAMES = ['readymade', 'readymades']
    DEFAULT_ATTRIBUTES = ['Will']

    def self.generate( *names )
       name       = names[0]
       more_names = names[1..-1]

       base = Readymade::Sheet.find_by( name: name )

       img = new( base.width, base.height )   ## make base a Readymade::Image copy
       img.compose!( base )

       img.add!( *more_names )
       img
    end # method Image.generate


    def add!( *names )
      names.each do |name|
         attribute = Punk::Sheet.find_by( name: name,
                                          gender: 'm' )
         compose!( attribute )
      end
      self
    end

    def add( *names )   ### todo/check: find a better name/alternate names - why? why not?
      img = self.class.new( width, height )  ## make a Readymade::Image copy
      img.compose!( self )

      img.add!( *names)
      img
    end
  end # class Image
end #  module Readymades




### add some convenience shortcuts
ReadyMade  = Readymade





#### add pre-configured readymade shortcuts
module Will
  class Image < Pixelart::Image

    NAMES = ['will', 'shakespeare',
             'willshakespeare',
             'williamshakespeare']
    def self.generate( *more_names )
       Readymade::Image.generate( 'William Shakespeare', *more_names )
    end # method Image.generate
  end # class Image
end  # module Will
Shakespeare  = Will


module Snoop
  class Image < Pixelart::Image

    NAMES = ['snoop', 'snoopdogg']
    def self.generate( *more_names )
       Readymade::Image.generate( 'Snoop Dogg', *more_names )
    end # method Image.generate
  end # class Image
end  # module Snoop
Snoopdogg  = Snoop
SnoopDogg  = Snoop

module Bart
  class Image < Pixelart::Image

    NAMES = ['bart', 'simpson', 'bartsimpson']
    def self.generate( *more_names )
       Readymade::Image.generate( 'Bart ', *more_names )
    end # method Image.generate
  end # class Image
end  # module Bart
Simpson  = Bart

module Mao
  class Image < Pixelart::Image

    NAMES = ['mao', 'maozedong']
    def self.generate( *more_names )
       Readymade::Image.generate( 'Mao Zedong', *more_names )
    end # method Image.generate
  end # class Image
end  # module Mao
Maozedong  = Mao
MaoZedong  = Mao






###
# note: for convenience auto include Pixelart namespace!!! - why? why not?
include Pixelart



puts Pixelart::Module::Readymades.banner    # say hello
