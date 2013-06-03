

def draw_square(window, x, y, z, width, height, color = 0xffffffff)
  window.draw_quad(x, y, color, x + width, y, color, x, y + height, color, x + width, y + height, color, z)
end


module WindowSettings
  @@window = nil
  @@scale_x = 0
  @@scale_y = 0
  @@x_offset = 0
  @@y_offset = 0
  
  def self.get_scale_x()
    return @@scale_x
  end
  
  def self.get_scale_y()
    return @@scale_y
  end
  
  def self.get_x_offset()
    return @@x_offset
  end
  
  def self.get_y_offset()
    return @@y_offset
  end
  
  def self.get_relative_x(x)
    return (x - @@x_offset) / @@scale_x
  end
  
  def self.get_relative_y(y)
    return (y - @@y_offset) / @@scale_y
  end
  
  def self.initialize(window, width, height, default_width, default_height)
    @@window = window
    @@scale_x = width / default_width.to_f()
    @@scale_y = height / default_height.to_f()
    @@x_offset = (width - (@@scale_x * default_width)) / 2
    @@y_offset = (height - (@@scale_y * default_height)) / 2
  end
  
  def self.formatted_draw(&block)
    @@window.translate(@@x_offset, @@y_offset) do
      @@window.scale(@@scale_x, @@scale_y) do
        @@window.clip_to(0, 0, 640, 640) do
          block.call()
        end
      end
    end
  end
end

