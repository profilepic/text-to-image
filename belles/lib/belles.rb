## our own "3rd" party gems
require 'artfactory/base'



## our own code
require_relative 'belles/version'    # note: let version always go first



module Belle

  class Spritesheet
    def self.builtin    ### check: use a different name e.g. default,standard,base or such - why? why not?
      @sheet ||= Pixelart::Spritesheet.read( "#{Pixelart::Module::Belles.root}/config/spritesheet.png",
                                             "#{Pixelart::Module::Belles.root}/config/spritesheet.csv",
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
      @generator ||= Artfactory.use(  Belle::Sheet.builtin,
                                      image_class: Image )
    end


    ## before callback/patch  for hats
     BEFORE_PATCH = ->(img, meta) {
      ## hack for hats & hair - clip head "overflow"
      ##  quick hack for headwear
      ##   cut-off/clean top overflow hair/head
      if meta.name.start_with?( 'beret' ) ||
         meta.name.start_with?( 'snap_back' )
           img[6,4] = 0
           img[7,3] = 0
           puts "  apply beau/belle hat & hair hack before '#{meta.name}' - clip head pixels..."
      elsif meta.name.start_with?( 'beanie' ) ||
            meta.name.start_with?( 'dreads' )
          img[6,4] = 0
          puts "  apply beau/belle hat & hair hack before '#{meta.name}' - clip head pixels..."
      else
          # do nothing; pass through as-is
      end
  }


   NAMES = ['belle', 'belles',
              'bella', 'bellas',
              'beau', 'beaus',
              'beaux']
    DEFAULT_ATTRIBUTES = ['Head 1',
                          'Shades Large Dark', 'Earring',
                          'Beanie Yellow', 'Pout 1', 'Turtleneck Rust']

    def self.generate( *names )
        generator.generate( *names, before: BEFORE_PATCH )
    end # method Image.generate
  end # class Image

end #  module Belle


### add some convenience shortcuts
Beaux  = Belle
Beau   = Belle
Bella  = Belle


###
# note: for convenience auto include Pixelart namespace!!! - why? why not?
include Pixelart



puts Pixelart::Module::Belles.banner    # say hello
