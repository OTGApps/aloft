class NilClass
  [:celcius, :fahrenheit, :knots, :mph].each do |method|
    define_method method do
      ''
    end
  end
end
