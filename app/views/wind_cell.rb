class WindCell < PM::TableViewCell
  attr_accessor :azimuth, :bearing, :speed, :temperature, :altitude

  # This method is used by ProMotion to instantiate cells.
  def initWithStyle(style_name, reuseIdentifier: reuseIdentifier)
    super
    @altitude       = rmq.append(UILabel)
    @bearing        = rmq.append(UILabel)
    @speed          = rmq.append(UILabel)
    @temperature    = rmq.append(UILabel)
    @azimuth        = rmq.append(Azimuth)
    @light_variable = rmq.append(UILabel)
    self
  end

  # Apply the styles once the cell is at the proper height
  def layoutSubviews
    # super # Remove this call to not draw the title and subtitle elements.

    @altitude.apply_style(:altitude)
    @azimuth.apply_style(:azimuth)
    @bearing.apply_style(:bearing)
    @speed.apply_style(:speed)
    @temperature.apply_style(:temperature)
    @light_variable.apply_style(:light_variable)
  end

  def set_attributes(view, attrs)
    [:altitude, :speed, :temperature, :azimuth, :light_variable, :bearing].each do |sym|
      self.send(sym.to_s << '=', attrs[sym]) if attrs[sym]
    end
  end

  def altitude= a
    @altitude.get.text = a
  end

  def speed= s
    @speed.get.text = s
  end

  def temperature= t
    @temperature.get.text = (t == '') ? '--' : t
  end

  def azimuth= i
    @azimuth.get.image = i
  end

  def light_variable= tf
    @light_variable.get.text = tf ? 'Light & Variable' : ''
  end

  def bearing= b
    if b.nil?
      @bearing.get.text = ''
      @azimuth.get.hidden = true
      return
    end

    @bearing.get.text = "#{b}°"
    @azimuth.get.tap do |a|
      a.hidden = false
      a.bearing = b
      a.observe_location
    end
  end
end
