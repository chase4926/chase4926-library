

module Alphabet
  class Text
    def initialize(window, message, scale=1)
      @image = record_image(window, message, scale)
    end
    
    def letter_to_index(letter)
      index = letter.upcase().ord() - 65
      if index == -33 then
        index = 27
      elsif index < 0 or index > 25
        index = 26
      end
      return index
    end
    
    def record_image(window, message, scale)
      message_array = []
      message.each_char do |letter|
        message_array << Alphabet.get_alphabet()[letter_to_index(letter)]
      end
      return window.record(message_array.count * (6 * scale), 7 * scale) do
        message_array.each_index do |i|
          message_array[i].draw(i * (6 * scale), 0, 0, scale, scale)
        end
      end
    end
    
    def draw(x, y, z)
      @image.draw(x, y, z)
    end
  end
  
  def self.initialize(window)
    Gosu::enable_undocumented_retrofication()
    @@alphabet_tilesheet = Gosu::Image::load_tiles(window, 'alphabet.png', 5, 7, false)
  end
  
  def self.get_alphabet()
    return @@alphabet_tilesheet
  end
end


__END__
# --- TEST ---

require 'rubygems'
require 'gosu'
include Gosu


class GameWindow < Gosu::Window
  def initialize()
    super(640, 640, false)
    self.caption = 'Alpha Test'
    Alphabet.initialize(self)
    @text1 = Alphabet::Text.new(self, 'Press any key to continue.', 4)
  end # End GameWindow Initialize
  
  def update()
  end # End GameWindow Update
  
  def draw()
    clip_to(0,0,640,640) do
      @text1.draw(0,0,0)
    end
  end # End GameWindow Draw
  
  def button_down(id)
    if id == KbEscape
      close
    end
  end
  
  def needs_cursor?
    true
  end
end # End GameWindow class


window = GameWindow.new().show()

