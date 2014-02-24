class WindCell < PM::TableViewCell
  attr_accessor :azimuth, :bearing, :speed, :altitude, :temperature

  # This method is used by ProMotion to instantiate cells.
  def initWithStyle(style_name, reuseIdentifier: reuseIdentifier)
    super
    rmq.stylesheet = CellStylesheet

    @altitude = rmq.append(UILabel)
    @azimuth = rmq.append(UIImageView)

    self
  end

  # Apply the styles once the cell is at the proper height
  def layoutSubviews
    super # Remove this call to not draw the title and subtitle elements.

    @altitude.apply_style(:altitude)
    @azimuth.apply_style(:azimuth)
  end

  def altitude= a
    @altitude.get.text = a
  end

  def azimuth= i
    @azimuth.get.image = i
  end

  def bearing= b
    # TODO: Make this Ease Out Elastic animation.
    UIView.animateWithDuration(2,
      delay: 0.2,
      options: UIViewAnimationOptionCurveEaseOut,
      animations: lambda {
        @azimuth.get.transform = CGAffineTransformMakeRotation(b.to_i * Math::PI / 180);
      },
      completion:lambda {|finished|
      }
    )
  end
end
