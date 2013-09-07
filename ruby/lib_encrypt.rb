=begin
  Blowfish module is from Phil Toland
=end

require 'openssl'
require 'yaml'


module OneTimePad
  def self.convert_to_only_letters(string)
    result = Array.new()
    string.each_char() do |char|
      if char.ord() >= 97 and char.ord() <= 122 then
        result << (char.ord() - 32).chr()
      elsif char.ord() >= 65 and char.ord() <= 90 then
        result << char
      end
    end
    return result.join()
  end
  
  def self.crypt(mode, message, key)
    mult = case mode
      when :en then 1
      when :de then -1
      else
        raise 'Invalid mode! Valid modes are :en, :de'
    end
    message = convert_to_only_letters(message)
    key = convert_to_only_letters(key)
    if message.length() == key.length() then
      result = Array.new()
      message.each_char() do |char|
        result << ((((char.ord() - 65) + (mult * (key[result.count()].ord() - 65))) % 26) + 65).chr()
      end
      return result.join()
    else
      raise 'Key length differs from message length!'
    end
  end
end


module Blowfish
  def self.cipher(mode, key, data)
    begin
      cipher = OpenSSL::Cipher::Cipher.new('bf-cbc').send(mode)
      cipher.key = Digest::SHA256.digest(key)
      cipher.update(data) << cipher.final
    rescue
    end
  end
  
  def self.encrypt(key, data)
    cipher(:encrypt, key, data)
  end
  
  def self.decrypt(key, text)
    cipher(:decrypt, key, text)
  end
end

def crypt(mode, key, data)
  case mode
    when :en
      data = data.to_yaml
      return Blowfish.encrypt(key, data)
    when :de
      data = Blowfish.decrypt(key, data)
      if data != nil then
        return YAML::load(data)
      end
  end
end

def newpass( len=30 )
  chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
  newpass = ""
  1.upto(len) { |i| newpass << chars[newpass_random(chars.size-1)] }
  return newpass
end

def newpass_random(max)
  srand
  return (0..max).to_a.sort_by{rand}.pop
end

def secure_crypt(mode, data, static_pass)
  if mode == 'en' then
    pass = newpass(50)
    data = [crypt('en', pass, data.to_yaml), pass.to_s.reverse].to_yaml
    return crypt('en', static_pass, data)
  elsif mode == 'de' then
    data = crypt('de', static_pass, data)
    if data != nil then
      data = YAML::load(data)
      return YAML::load(crypt('de', data[1].reverse, data[0]))
    end
  end
end
