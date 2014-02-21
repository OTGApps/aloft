class Distance
  attr_reader :meters

  def initialize(meters)
    @meters = meters
  end

  def miles
    @meters * 0.000621371192
  end

  def <=> other
    @meters <=> other.meters
  end

end
