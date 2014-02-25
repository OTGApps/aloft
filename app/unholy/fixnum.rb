class Fixnum
  def self.celcius
    "#{self}° C"
  end

  def self.fahrenheit
    "#{(self * 1.8) + 32}° F"
  end
end
