class WindCell < PM::TableViewCell
  attr_accessor :azimuth, :bearing, :speed, :altitude, :temperature

  # This method is used by ProMotion to instantiate cells.
  def initWithStyle(style_name, reuseIdentifier: reuseIdentifier)
    super
    rmq.stylesheet = CellStylesheet

    @altitude = rmq.append(UILabel)
    # @azimuth = rmq.append(UIImage).get

    self
  end

  # Apply the styles once the cell is at the proper height
  def layoutSubviews
    @altitude.apply_style(:altitude)
    # @azimuth.get.apply_style(:azimuth)
  end

  def altitude= a
    @altitude.get.text = a
  end

  # def azimuth= i
  #   @azimuth.image = i
  # end

end
