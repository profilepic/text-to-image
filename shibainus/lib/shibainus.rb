## our own "3rd" party gems
require 'artfactory/base'



## our own code
require_relative 'shibainus/version'    # note: let version always go first



module Shibainu

  class Spritesheet
   def self.builtin    ### check: use a different name e.g. default,standard,base or such - why? why not?
      @sheet ||= Pixelart::Spritesheet.read( "#{Pixelart::Module::Shibainus.root}/config/spritesheet.png",
                                             "#{Pixelart::Module::Shibainus.root}/config/spritesheet.csv",
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

   def self.generator
      @generator ||= Artfactory.use(  Shibainu::Sheet.builtin,
                                      image_class: Image )
    end

   ## before callback/patch  for hats
     BEFORE_PATCH = ->(img, meta) {
      ## hack for doge hats - cut off / clean top (ears)
       if ['beanie',
           'cap',
           'capforward',
           'cowboyhat',
           'fedora',
           'bandana',
           'tophat',
           'knittedcap'].include?( meta.name )
            puts "  apply doge headwear (for hats & more) hack before '#{meta.name}' - wipe-out pixel lines 3,4,5 (top e.g. doge ears)..."

            ## "wipe-out" pixel lines 3,4,5 (top)
           [3,4,5].each do |y|
              img.width.times do |x|
                 img[ x, y ] = 0  # transparent color
              end
           end
        end
   }


    NAMES = ['doge', 'doges',
             'shiba', 'shibas',
             'shibainu', 'shibainus']
    DEFAULT_ATTRIBUTES = ['Classic']

    def self.generate( *names )
      generator.generate( *names, before: BEFORE_PATCH )
     end # method Image.generate
  end # class Image
end #  module Shibainu



### add some convenience shortcuts
ShibaInu  = Shibainu
Shiba     = Shibainu
Shib      = Shibainu

## add doge alias/shortcut too - why? why not?
Doge      = Shibainu


###
# note: for convenience auto include Pixelart namespace!!! - why? why not?
include Pixelart



puts Pixelart::Module::Shibainus.banner    # say hello
