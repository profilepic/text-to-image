## 3rd party
require 'artfactory/base'



## our own code
require_relative 'smileys/version'    # note: let version always go first


module Smiley15    ## smiley circle with 15px diameter in 24x24 canvas

  class Spritesheet
    def self.builtin
      @sheet ||= Pixelart::Spritesheet.read( "#{Pixelart::Module::Smileys.root}/config/spritesheet_dia15-24x24.png",
                                             "#{Pixelart::Module::Smileys.root}/config/spritesheet_dia15-24x24.csv",
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
      @generator ||= Artfactory.use(  Smiley15::Sheet.builtin,
                                      image_class: Image )
    end


    NAMES = ['smiley15', 'smileys15' ]
    DEFAULT_ATTRIBUTES = ['Yellow', 'Face 1']

    def self.generate( *names )
       generator.generate( *names )
    end
  end # class Image
end




module Smiley16    ## smiley circle with 16px diameter in 24x24 canvas

  class Spritesheet       ## note: for now class used for "namespace" only
    def self.builtin    ### check: use a different name e.g. default,standard,base or such - why? why not?
      @sheet ||= Pixelart::Spritesheet.read( "#{Pixelart::Module::Smileys.root}/config/spritesheet_dia16-24x24.png",
                                             "#{Pixelart::Module::Smileys.root}/config/spritesheet_dia16-24x24.csv",
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
      @generator ||= Artfactory.use(  Smiley16::Sheet.builtin,
                                      image_class: Image )
    end


    NAMES = ['smiley16', 'smileys16',
             'smiley', 'smileys' ]
    DEFAULT_ATTRIBUTES = ['Yellow', 'Face 1']

    def self.generate( *names )
       generator.generate( *names )
    end
  end # class Image
end

Smiley = Smiley16    ## note: make Smiley16 the DEFAULT Smiley (if no diameter specified)




module Smiley17    ## smiley circle with 17px diameter in 24x24 canvas

  class Spritesheet       ## note: for now class used for "namespace" only
    def self.builtin    ### check: use a different name e.g. default,standard,base or such - why? why not?
      @sheet ||= Pixelart::Spritesheet.read( "#{Pixelart::Module::Smileys.root}/config/spritesheet_dia17-24x24.png",
                                             "#{Pixelart::Module::Smileys.root}/config/spritesheet_dia17-24x24.csv",
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
      @generator ||= Artfactory.use(  Smiley17::Sheet.builtin,
                                      image_class: Image )
    end


    NAMES = ['smiley17', 'smileys17' ]
    DEFAULT_ATTRIBUTES = ['Yellow', 'Face 1']

    def self.generate( *names )
       generator.generate( *names )
    end
  end # class Image
end



module Smiley20   ## smiley circle with 20px diameter in 24x24 canvas

  class Spritesheet       ## note: for now class used for "namespace" only
    def self.builtin    ### check: use a different name e.g. default,standard,base or such - why? why not?
      @sheet ||= Pixelart::Spritesheet.read( "#{Pixelart::Module::Smileys.root}/config/spritesheet_dia20-24x24.png",
                                             "#{Pixelart::Module::Smileys.root}/config/spritesheet_dia20-24x24.csv",
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
      @generator ||= Artfactory.use(  Smiley20::Sheet.builtin,
                                      image_class: Image )
    end


    NAMES = ['smiley20', 'smileys20' ]
    DEFAULT_ATTRIBUTES = ['Yellow', 'Face 1']

    def self.generate( *names )
       generator.generate( *names )
    end
  end # class Image
end





###
# note: for convenience auto include Pixelart namespace!!! - why? why not?
include Pixelart


puts Pixelart::Module::Smileys.banner    # say hello

