class Color
  attr_accessor :color

  def initialize(color)
    @color = color
  end

  def lighten(amount)
    hex_color = color.gsub('#','')
    rgb = hex_color.scan(/../).map {|color| color.hex}
    rgb[0] = [(rgb[0].to_i + 255 * amount).round, 255].min
    rgb[1] = [(rgb[1].to_i + 255 * amount).round, 255].min
    rgb[2] = [(rgb[2].to_i + 255 * amount).round, 255].min
    Color.new("#%02x%02x%02x" % rgb)
  end

  def to_color
    @color.to_color
  end
end
