

module Lighting
  class Lit_Object
    def initialize()
      @static_level = 0
      @dynamic_level = 0
      @color = Gosu::Color.rgba(0, 0, 0, 255)
      @dynamic_array = []
    end
    
    def static_light_block(&block) # Static updates should be made within this block
      block.call()
      update_color()
    end
    
    def dynamic_light_block(&block) # All dynamic updates should be called within this block
      @dynamic_array = [0]
      block.call()
      update_color()
    end
    
    def calculate_static_light(radius, brightness, source_x, source_y, block_x, block_y)
      distance_from_source = Gosu::distance(block_x, block_y, source_x, source_y).round()
      if distance_from_source > radius then
        # Outside Radius
        return @static_level
      else
        # Within Radius
        calculated_level = (brightness - ((distance_from_source * brightness).to_f / radius.to_f).round) # This is the level that is calculated, not final result.
        if calculated_level < @static_level then
          return @static_level
        else
          return calculated_level
        end
      end
    end
    
    def calculate_dynamic_light(radius, brightness, source_x, source_y, block_x, block_y)
      distance_from_source = Gosu::distance(block_x, block_y, source_x, source_y).round()
      if distance_from_source > radius then
        # Outside of radius, doesn't need to be calculated
        return nil
      end
      # Within radius
      return (brightness - ((distance_from_source * brightness).to_f / radius.to_f).round) # The master equation: dist/radius = x/brightness
    end
    
    def update_light(type, radius, brightness, source_x, source_y) # Updates the light level variables
      case type
        when :static
          @static_level = calculate_static_light(radius, brightness, source_x, source_y, @x, @y)
        when :dynamic
          calculated_level = calculate_dynamic_light(radius, brightness, source_x, source_y, @x, @y)
          @dynamic_array << calculated_level if calculated_level != nil
          @dynamic_level = @dynamic_array.max()
      end
    end
    
    def update_color() # This updates the @color variable to the highest brightness allowed
      if @static_level >= @dynamic_level then
        @color = Lighting[@static_level]
      else
        @color = Lighting[@dynamic_array.max()]
      end
    end
  end
  
  @@preloaded_colors = []
  
  def self.initialize_lighting() # This function does not need to be manually called
    @@preloaded_colors = get_preloaded_colors()
  end
  
  def self.get_preloaded_colors() # Returns an array of Gosu::Colors; maybe this performs better?
    result = []
    256.times do |i|
      result[i] = Gosu::Color.rgba(i, i, i, 255)
    end
    return result
  end
  
  def self.[](index) # Returns the preloaded color for the index (index == brightness)
    initialize_lighting() if @@preloaded_colors.empty?()
    return @@preloaded_colors[index]
  end
end

