class Fixnum
  def celcius
    "#{self}° C"
  end

  def fahrenheit
    "#{((self * 1.8) + 32).round(1)}° F"
  end

  def knots
    "#{self} knots"
  end

  def mph
    "#{(self * 1.15077945).round(1)} mph"
  end
end
