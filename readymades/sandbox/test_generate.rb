###
#  to run use
#     ruby -I ./lib sandbox/test_generate.rb



require 'readymades'


names = [
  'William Shakespeare',
  'Bart Simpson',
  'Dante Alighieri',
  'Galileo Galilei',
  'Mao Zedong',
  'Snoop Dogg',
  'Terminator',
  'The Joker',
  'The Grinch',
  'The Mask',
]

variants = [
  [],   ## none
  ['Heart Shades'],
  ['Heart Shades', 'Birthday Hat', 'Bubble Gum'],
  ['Headband', 'Pipe'],
  ['Pipe', '3D Glasses', 'Cap Forward'],
  ['Nerd Glasses', 'Beanie'],
  ['Horned Rim Glasses', 'Earring'],
  ['VR'],
  ['Hoodie'],
]


punks  = ImageComposite.new( variants.size, names.size, background: '#638596' )


names.each do |name|
  variants.each_with_index do |attributes, i|
     punk = Readymade::Image.generate( name, *attributes )

     slug = name.downcase.gsub( ' ', '_' )

     punk.save( "./tmp/#{slug}#{i}.png")
     punk.zoom(4).save( "./tmp/#{slug}#{i}@4x.png")

     punks << punk
  end
end

punks.save( "./tmp/readymades.png" )
punks.zoom(4).save( "./tmp/readymades@4x.png" )



punks  = ImageComposite.new( 3, 3, background: '#638596' )

variants.each_with_index do |attributes, i|
  name = 'Hannibal'
  punk = Readymade::Image.generate( name, *attributes )

  slug = name.downcase.gsub( ' ', '_' )

  punk.save( "./tmp/#{slug}#{i}.png")
  punk.zoom(4).save( "./tmp/#{slug}#{i}@4x.png")

  punks << punk
end

punks.save( "./tmp/readymades-hannibals.png" )
punks.zoom(4).save( "./tmp/readymades-hannibals@4x.png" )




base = Readymade::Image.generate( 'Will', '3D Glasses', 'Earring' )  ## note: use a "base" punk for background variants
punk = base.background( 'Ukraine' )
punk.save( "./tmp/will0.png")
punk.zoom(8).save( "./tmp/will0@8x.png")

punk = base.background( 'Red' )
punk.save( "./tmp/will1.png")
punk.zoom(8).save( "./tmp/will1@8x.png")



base = Readymade::Image.generate( 'Snoop Dogg', 'VR', 'Earring' )  ## note: use a "base" punk for background variants
punk = base.background( 'Ukraine')
punk.save( "./tmp/snoop0.png")
punk.zoom(8).save( "./tmp/snoop0@8x.png")

punk = base.background( 'Red' )
punk.save( "./tmp/snoop1.png")
punk.zoom(8).save( "./tmp/snoop1@8x.png")



base = Readymade::Image.generate( 'Terminator' )

punk = base.add( 'VR' )      ## build in steps
punk.save( "./tmp/terminator.png")
punk.zoom(8).save( "./tmp/terminator@8x.png")

punk = punk.background( 'Matrix 1', 'Rainbow 1' )
punk.save( "./tmp/terminator-bg.png")
punk.zoom(8).save( "./tmp/terminator-bg@8x.png")


#####
#  test readymade shortcuts


punk = Will::Image.generate
punk.save( "./tmp2/will.png")
punk.zoom(8).save( "./tmp2/will@8x.png")

punk = Will::Image.generate( '3D Glasses' )
punk.save( "./tmp2/will2.png")
punk.zoom(8).save( "./tmp2/will2@8x.png")

punk = Will::Image.generate( 'VR' )
punk.save( "./tmp2/will3.png")
punk.zoom(8).save( "./tmp2/will3@8x.png")



punk = Snoop::Image.generate
punk.save( "./tmp2/snoop.png")
punk.zoom(4).save( "./tmp2/snoop@4x.png")
punk.zoom(8).save( "./tmp2/snoop@8x.png")

punk = Snoop::Image.generate( '3D Glasses' )
punk.save( "./tmp2/snoop2.png")
punk.zoom(4).save( "./tmp2/snoop2@4x.png")
punk.zoom(8).save( "./tmp2/snoop2@8x.png")

punk = Snoop::Image.generate( 'VR' )
punk.save( "./tmp2/snoop3.png")
punk.zoom(4).save( "./tmp2/snoop3@4x.png")
punk.zoom(8).save( "./tmp2/snoop3@8x.png")


punk = Bart::Image.generate
punk.save( "./tmp2/bart.png")
punk.zoom(8).save( "./tmp2/bart@8x.png")

punk = Bart::Image.generate( '3D Glasses')
punk.save( "./tmp2/bart2.png")
punk.zoom(8).save( "./tmp2/bart2@8x.png")

punk = Bart::Image.generate( 'VR')
punk.save( "./tmp2/bart3.png")
punk.zoom(8).save( "./tmp2/bart3@8x.png")


punk = Mao::Image.generate
punk.save( "./tmp2/mao.png")
punk.zoom(8).save( "./tmp2/mao@8x.png")

punk = Mao::Image.generate( '3D Glasses')
punk.save( "./tmp2/mao2.png")
punk.zoom(8).save( "./tmp2/mao2@8x.png")

punk = Mao::Image.generate( 'VR')
punk.save( "./tmp2/mao3.png")
punk.zoom(8).save( "./tmp2/mao3@8x.png")



punk = Mundl::Image.generate
punk.save( "./tmp2/mundl.png")
punk.zoom(4).save( "./tmp2/mundl@4x.png")
punk.zoom(8).save( "./tmp2/mundl@8x.png")

punk = Mundl::Image.generate( '3D Glasses' )
punk.save( "./tmp2/mundl2.png")
punk.zoom(4).save( "./tmp2/mundl2@4x.png")
punk.zoom(8).save( "./tmp2/mundl2@8x.png")

punk = Mundl::Image.generate( 'VR' )
punk.save( "./tmp2/mundl3.png")
punk.zoom(4).save( "./tmp2/mundl3@4x.png")
punk.zoom(8).save( "./tmp2/mundl3@8x.png")



base = Readymade::Image.generate( 'Snoop Dogg', 'VR', 'Earring' )  ## note: use a "base" punk for background variants
punk = base.background( 'Ukraine')
punk.save( "./tmp/snoop0.png")
punk.zoom(8).save( "./tmp/snoop0@8x.png")

punk = base.background( 'Red' )
punk.save( "./tmp/snoop1.png")
punk.zoom(8).save( "./tmp/snoop1@8x.png")



base = Readymade::Image.generate( 'Mundl' )

punk = base.add( 'VR' )      ## build in steps
punk = punk.background( 'Ukraine')
punk.save( "./tmp2/mundl_i.png")
punk.zoom(4).save( "./tmp2/mundl_i@4x.png")
punk.zoom(8).save( "./tmp2/mundl_i@8x.png")

punk = base.add( '3D Glasses' )      ## build in steps
punk = punk.background( 'Red' )
punk.save( "./tmp2/mundl_ii.png")
punk.zoom(8).save( "./tmp2/mundl_ii@8x.png")

punk = base.add( '3D Glasses', 'Cigarette', 'Smile' )      ## build in steps
punk = punk.stripes_horizontal( '#C8102E', '#FFFFFF', '#C8102E' )
punk.save( "./tmp2/mundl_iii.png")
punk.zoom(4).save( "./tmp2/mundl_iii@4x.png")
punk.zoom(8).save( "./tmp2/mundl_iii@8x.png")



punk = base.add( 'VR' )         ## build in steps
punk = punk.background( 'Matrix 1', 'Rainbow 1' )
punk.save( "./tmp2/mundl_iiii.png")
punk.zoom(8).save( "./tmp2/mundl_iiii@8x.png")


puts "bye"
