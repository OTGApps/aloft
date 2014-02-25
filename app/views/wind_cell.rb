class WindCell < PM::TableViewCell
  attr_accessor :azimuth, :bearing, :speed, :temperature, :altitude

  # This method is used by ProMotion to instantiate cells.
  def initWithStyle(style_name, reuseIdentifier: reuseIdentifier)
    super
    rmq.stylesheet = CellStylesheet

    @altitude    = rmq.append(UILabel)
    @bearing     = rmq.append(UILabel)
    @speed       = rmq.append(UILabel)
    @temperature = rmq.append(UILabel)
    @azimuth     = rmq.append(UIImageView)

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
  end

  def altitude= a
    @altitude.get.text = a
  end

  def speed= s
    @speed.get.text = s
  end

  def temperature= t
    @temperature.get.text = t
  end

  def azimuth= i
    @azimuth.get.image = i
  end

  def bearing= b
    if b.nil?
      @bearing.get.text = ''
      @azimuth.get.hidden = true
      return
    end

    @bearing.get.text = "#{b}°"

    @azimuth.get.hidden = false
    UIView.animateWithDuration(2.0,
      delay:0.3,
      usingSpringWithDamping:0.3,
      initialSpringVelocity:0.2,
      options:UIViewAnimationOptionCurveLinear,
      animations: lambda {
        radians = CGAffineTransformMakeRotation(b.to_i * Math::PI / 180);
        @azimuth.get.transform = radians
      },
      completion:lambda {|finished|
      }
    )
  end
end
