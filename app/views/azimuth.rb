class Azimuth < UIImageView
  def observe_location
    App.notification_center.observe 'HeadingUpdate' do |notification|
      @phone_heading = notification.object
      animate_to_bearing(0)
    end

    App.notification_center.observe 'StopHeadingUpdates' do |notification|
      puts 'Stopping heading updates.'
      spring_to_bearing
    end
  end

  def bearing=(b)
    @bearing = b
    animate_to_bearing
  end

  def combined_bearing
    (@bearing || 0) - (@phone_heading || 0)
  end

  def animate_to_bearing(timing = 2.0)
    UIView.animateWithDuration(timing,
      delay:0.0,
      options:UIViewAnimationOptionCurveLinear,
      animations: lambda {
        radians = CGAffineTransformMakeRotation(combined_bearing.to_i * Math::PI / 180);
        self.transform = radians
      },
      completion:lambda {|finished|
      }
    )
  end

  # This animation is used only when the user doesn't want compass updates.
  def spring_to_bearing(timing = 2.0)
    UIView.animateWithDuration(timing,
      delay:0.3,
      usingSpringWithDamping:0.3,
      initialSpringVelocity:0.2,
      options:UIViewAnimationOptionCurveLinear,
      animations: lambda {
        radians = CGAffineTransformMakeRotation(combined_bearing.to_i * Math::PI / 180);
        self.transform = radians
      },
      completion:lambda {|finished|
      }
    )
  end
end
