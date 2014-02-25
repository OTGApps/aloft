class WindCell < PM::TableViewCell
  attr_accessor :azimuth, :bearing, :speed, :altitude, :temperature

  # This method is used by ProMotion to instantiate cells.
  def initWithStyle(style_name, reuseIdentifier: reuseIdentifier)
    super
    rmq.stylesheet = CellStylesheet

    @altitude = rmq.append(UILabel)
    @bearing = rmq.append(UILabel)
    @azimuth = rmq.append(UIImageView)

    self
  end

  # Apply the styles once the cell is at the proper height
  def layoutSubviews
    # super # Remove this call to not draw the title and subtitle elements.

    @altitude.apply_style(:altitude)
    @azimuth.apply_style(:azimuth)
    @bearing.apply_style(:bearing)
  end

  def altitude= a
    @altitude.get.text = a
  end

  def azimuth= i
    @azimuth.get.image = i
  end

  def bearing= b
    b = 0 if b.nil?

    @bearing.get.text = b.to_s

    UIView.animateWithDuration(2.0,
      delay:1.0,
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
