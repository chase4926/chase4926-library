=begin
Copyright Chase Arnold

Two types of lighting:
-Static
  When calculating will take into account previous static level --- returns 0-<brightness> (max 255)
  ex. def calculate_static_light( radius, brightness, previous_static, source_x, source_y, block_x, block_y )
    in pixels: radius, source_x, source_y, block_x, block_y
    in light(0-255): previous_static, brightness
-Dynamic
  When calculating will take into account previous static and other dynamic sources --- returns 0-255
  ex. def calculate_dynamic_light( radius, brightness, source_x, source_y, block_x, block_y )
    in pixels: radius, source_x, source_y, block_x, block_y
    in light(0-255): brightness
    
How the game will reference this:
  When the map is first drawn all the static light sources will be calculated on all the blocks in the map once for each static source.
  Every update() the GameWindow should call calculate_dynamic_light on all the blocks in the map once for each dynamic source.
    (Is there a better way to do this?)
  Then the produced static and dynamic levels should be stored (respectively) into variables on each block.
  When the blocks are drawn, they should be drawn similar to this:
    def update()
      color = Gosu::Color.rgba(@dynamic_level, @dynamic_level, @dynamic_level, 255)
    end
    def draw()
      @image.draw(@x, @y, 0, 1, 1, @color)
    end
  A variable called @color gets assigned the correct color automatically now, just use updatecolor().


Steps to get lighting going in your game:

1. Set up a class similar to this:

    class Block<Lighting
      attr_accessor :x, :y
      
      def initialize(window)
        @image = Gosu::Image.new(window, "media/block.png", false)
        @x = @y = 0
        lighting_initialize()
      end
      
      def draw()
        @image.draw(@x, @y, 1, 1, 1, @color)
      end
    end

2. In your GameWindow's update() run: x.updatecolor() *x represents each of your blocks
    Note: I HIGHLY recommend using the get_preloaded_colors feature. This can speed up the processing amazingly.
    Just set a variable to it - @preloaded_colors = get_preloaded_colors - then when you update your colors, do - updatecolor( @preloaded_colors )

3. Then all that's left is to add the lights.
     For Static: After the map is loaded and all blocks are generated, iterate through all light-affected objects and use: 
                                                      block.updatelight( 'static', radius, brightness, source_x, source_y )
     For Dynamic: After the map is loaded and all blocks are generated, iterate through all light-affected objects in update() and use:
                                                      block.updatelight( 'dynamic', radius, brightness, source_x, source_y, light_id ) 
                                                      *light_id is the id of the light, uses array-like numbering. ex. first light->light_id = 0, second light-> light_id = 1, etc.
=end

class Lighting
  def calculate_static_light( radius, brightness, previous_static, source_x, source_y, block_x, block_y )
    distance_from_source = Gosu::distance( block_x, block_y, source_x, source_y ).round
    if distance_from_source < radius then
      # Within Radius
      calculated_level = (255 - ((distance_from_source * brightness).to_f / radius.to_f).round) # This is the level that is calculated, not final result.
      if calculated_level < previous_static then
        return previous_static
      else
        return calculated_level
      end
    else
      # Outside Radius
      return previous_static
    end
  end
    
  def calculate_dynamic_light( radius, brightness, source_x, source_y, block_x, block_y )
    distance_from_source = Gosu::distance( block_x, block_y, source_x, source_y ).round
    if distance_from_source > radius then
      # Outside of radius
      return brightness
    end
    # Within radius
    #calculated_level = (255 - ((distance_from_source * brightness).to_f / radius.to_f).round) # This is the level that is calculated, not final result. This is the old way, a hackish approach is below
    calculated_level = (255 - ((distance_from_source * 255).to_f / radius.to_f).round) # This is the level that is calculated, not final result.
    #calculated_level -= (255 - brightness) # This is the hacky solution, the above formula is not correct when I try to use brightness like that.
    
    #if calculated_level <= brightness then
      #calculated_level = brightness
    #end
    return calculated_level
  end
  
  def lighting_initialize() # Initialize all the variables for a block
    @static_level = @dynamic_level = 0
    @color = Gosu::Color.rgba(0, 0, 0, 255)
    @dynamic_array = []
  end
  
  def start_light_block()
    @dynamic_array = []
  end
  
  def updatelight(type, radius, brightness, source_x, source_y) # Update the lighting on a block
    if type == 'static' then
      @static_level = calculate_static_light( radius, brightness, @static_level, source_x, source_y, @x, @y )
    elsif type == 'dynamic' then
      @dynamic_array << calculate_dynamic_light( radius, brightness, source_x, source_y, @x, @y )
      @dynamic_level = @dynamic_array.max
    end
  end
  
  def updatecolor( preloaded=nil )
    if preloaded != nil then
      if @static_level >= @dynamic_level then
        @color = preloaded[@static_level]
      else
        biggest_dynamic_number = @dynamic_array.max
        @color = preloaded[biggest_dynamic_number]
      end
    else
      if @static_level >= @dynamic_level then
        @color = Gosu::Color.rgba(@static_level, @static_level, @static_level, 255)
      else
        biggest_dynamic_number = @dynamic_array.max
        @color = Gosu::Color.rgba(biggest_dynamic_number, biggest_dynamic_number, biggest_dynamic_number, 255)
      end
    end
  end
  
  def get_preloaded_colors()
    result = []
    256.times do |i|
      result[i] = Gosu::Color.rgba(i, i, i, 255)
    end
    return result
  end
end
