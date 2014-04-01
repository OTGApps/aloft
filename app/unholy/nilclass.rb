class NilClass
  # So we can call nil.clecius etc. and not get an error.
  [:celcius, :fahrenheit, :knots, :mph].each do |method|
    define_method method do
      ''
    end
  end
end
