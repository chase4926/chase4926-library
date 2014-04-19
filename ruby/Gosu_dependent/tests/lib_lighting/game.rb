#!/usr/bin/env ruby

=begin
I marked the important lines with #--!!
I'm someone who learns by reading examples, so hopefully this will be sufficient
for other people.
=end


require 'rubygems'
require 'gosu'
include Gosu

$VERBOSE = true

# I left a spare copy of my current libraries in case I change them in the future
require_relative 'lib/lib'
require_relative 'lib/lib_misc'
require_relative 'lib/lib_medialoader'
#--
# Except for this one, it's explicitly a test for the new version, so I'll change the test if I ever change the library
# ...Hopefully I will anyway
require_relative '../../lib_lighting'
#--


class GameWindow < Gosu::Window
  def initialize()
    super(640, 480, false)
    self.caption = 'New Lighting Test'
    Media::initialize(self, 'images', 'sounds', 'tilesets')
    @map = Map.new(self)
  end # End GameWindow Initialize
  
  def update()
  end # End GameWindow Update
  
  def draw()
    @map.draw()
  end # End GameWindow Draw
  
  def button_down(id)
    case id
      when Gosu::Button::KbEscape
        close()
    end
  end
  
  def needs_cursor?()
    return true
  end
end # End GameWindow class


class Tile < Lighting::Lit_Object #--!! Needs to inherit
  def initialize(x, y)
    super() #--!! Don't forget this!
    @image = Media::get_image('grass.png')
    @x = x
    @y = y
  end
  
  def draw()
    @image.draw(@x, @y, 0, 1, 1, @color) #--!! Make sure to include @color when drawing
  end
end


class Map
  def initialize(window)
    @window = window
    @map_array = Array.new(15){Array.new(20)}
    @map_array.each_with_index() do |item, y|
      item.each_index() do |x|
        @map_array[y][x] = Tile.new(x*32, y*32)
        @map_array[y][x].static_light_block() do #--!!
          @map_array[y][x].update_light(:static, 192, 255, 128, 128) #--!!
          @map_array[y][x].update_light(:static, 192, 200, 192, 128) #--!!
        end
      end
    end
  end
  
  def draw()
    @map_array.each() do |row|
      row.each() do |tile|
        tile.dynamic_light_block() do #--!!
          # Update all dynamic lights here
          tile.update_light(:dynamic, 192, 255, @window.mouse_x - 16, @window.mouse_y - 16) #--!!
          tile.update_light(:dynamic, 192, 155, (@window.mouse_x * -1) + 640 - 16, (@window.mouse_y * -1) + 480 - 16) #--!!
        end
        tile.draw()
      end
    end
  end
end


window = GameWindow.new().show()