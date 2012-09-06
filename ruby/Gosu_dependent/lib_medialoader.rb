

def recursive_search_directory(directory, path_so_far=nil)
  result = Dir.glob(File.join(directory, '**/*'))
  result.each_index do |i|
    result[i] = nil if File.directory?(result[i])
  end
  return result.compact()
end


module Media
  @@images_hash = {}
  @@sounds_hash = {}
  
  def self.get_sound(key)
    return @@sounds_hash[key]
  end
  
  def self.get_image(key)
    return @@images_hash[key]
  end
  
  def self.load_images(window, path)
    recursive_search_directory(path).each do |image_path|
      @@images_hash[image_path.split(File.join(path,''), 2)[1]] = Image.new(window, image_path, true)
    end
  end
  
  def self.load_sounds(window, path, samples_folder='samples', songs_folder='songs')
    samples_folder = File.join(path, samples_folder)
    songs_folder = File.join(path, songs_folder)
    
    if File.directory?(samples_folder) then
      # Load samples
      recursive_search_directory(samples_folder).each do |sample_path|
        @@sounds_hash[sample_path.split('/', 3)[2]] = Sample.new(window, sample_path)
      end
    elsif $VERBOSE then
      puts "'#{samples_folder}' directory not found, no samples were loaded"
    end
    
    if File.directory?(songs_folder) then
      # Load songs
      recursive_search_directory(songs_folder).each do |song_path|
        @@sounds_hash[song_path.split('/', 3)[2]] = Song.new(window, song_path)
      end
    elsif $VERBOSE then
      puts "'#{songs_folder}' directory not found, no songs were loaded"
    end
  end
  
  def self.initialize(window, images_directory, sounds_directory)
    images_path = File.join(File.dirname(__FILE__), images_directory)
    sounds_path = File.join(File.dirname(__FILE__), sounds_directory)
    
    if File.directory?(images_path) then
      # Load images
      self.load_images(window, images_path)
    elsif $VERBOSE then
      puts "'#{images_directory}' directory not found, images were not loaded!"
    end
    if File.directory?(sounds_path) then
      # Load sounds
      self.load_sounds(window, sounds_path)
    elsif $VERBOSE then
      puts "'#{sounds_directory}' directory not found, sounds were not loaded!"
    end
  end
end


__END__
# --- TEST ---

$VERBOSE = true

require 'rubygems'
require 'gosu'
include Gosu


class GameWindow < Gosu::Window
  def initialize()
    super(256, 256, false)
    self.caption = 'Media Loader test'
    Media::initialize(self, 'images', 'sounds')
    Media::get_sound('songs/song1.ogg').play()
    @image = Media::get_image('wall.png')
    @angle = rand(360)
  end # End GameWindow Initialize
  
  def update()
    @angle += 2
  end # End GameWindow Update
  
  def draw()
    10.times do
      @image.draw_rot(rand(128) + 48, rand(128) + 48, 0, @angle)
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

