module ShareCells
  def share_cells
    [{
      title: 'Share the app',
      subtitle: 'Text, Email, Tweet, or Facebook!',
      image: 'share',
      action: :share
    }, {
      title: "Rate #{App.name} on iTunes",
      action: :rate_itunes,
      image: 'itunes'
    }]
  end

  def share
    BW::UIActivityViewController.new(
      items: "I'm using the '#{App.name}' app to check NOAA winds aloft forecasts. Check it out! http://www.mohawkapps.com/app/aloft/",
      animated: true,
      excluded: excluded_services
    ) do |activity_type, completed|
      # Flurry.logEvent("SHARE_COMPLETED") unless Device.simulator
    end

    # Flurry.logEvent("SHARE_TAPPED") unless Device.simulator?
  end

  def rate_itunes
    Appirater.rateApp
    # Flurry.logEvent("RATE_ITUNES_TAPPED") unless Device.simulator?
  end

  def excluded_services
    [
      UIActivityTypeAddToReadingList,
      UIActivityTypeAirDrop,
      UIActivityTypeCopyToPasteboard,
      UIActivityTypePrint
    ]
  end
end
