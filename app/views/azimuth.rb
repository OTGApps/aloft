class Azimuth < UIImageView
  def observe_location
    @observing ||= begin
      App.notification_center.observe 'HeadingUpdate' do |notification|
        @phone_heading = notification.object
        animate_to_bearing
      end

      App.notification_center.observe 'StopHeadingUpdates' do |notification|
        ap 'Stopping heading updates.' if BW.debug?
        animate_to_bearing
      end
    end
  end

  def bearing=(b)
    @original_bearing ||= b
    @bearing = b

    @initial_animation ||= begin
      animate_to_bearing
    end
  end

  def combined_bearing
    (@bearing || 0) - (@phone_heading || 0)
  end

  def animate_to_bearing
    if App::Persistence['compass'] == false
      ap "Animating - compass is off" if BW.debug?
      return spring_to_original_bearing
    end

    UIView.animateWithDuration(0.0,
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
  def spring_to_original_bearing(timing = 2.0)
    UIView.animateWithDuration(timing,
      delay:0.3,
      usingSpringWithDamping:0.3,
      initialSpringVelocity:0.2,
      options:UIViewAnimationOptionCurveLinear,
      animations: lambda {
        radians = CGAffineTransformMakeRotation(@original_bearing.to_i * Math::PI / 180);
        self.transform = radians
      },
      completion:lambda {|finished|
      }
    )
  end
end
