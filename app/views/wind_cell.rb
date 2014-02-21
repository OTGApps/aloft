class WindCell < PM::TableViewCell
  attr_accessor :azimuth, :bearing, :speed, :altitude, :temperature

  # This method is used by ProMotion to instantiate cells.
  def initWithStyle(style_name, reuseIdentifier: reuseIdentifier)
    super
    rmq.stylesheet = CellStylesheet

    # @altitude = rmq.append(UILabel, :altitude).get

    self
  end

  # def altitude= a
  #   @altitude.text = a
  # end

end
