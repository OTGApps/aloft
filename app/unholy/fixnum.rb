class Fixnum
  def celcius
    "#{self}° C"
  end

  # The numbers are always in celcuis
  def fahrenheit
    "#{((self * 1.8) + 32).round(1)}° F"
  end

  def knots
    "#{self} knots"
  end

  # The numbers are always in knots
  def mph
    "#{(self * 1.15077945).round(1)} mph"
  end
end
