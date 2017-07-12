module SettingsCells
  def settings_cells
    [{
      title: 'Use Metric Units',
      subtitle: 'You can also tap altitudes to change this.',
      accessory: {
        view: :switch,
        action: :switched,
        value: App::Persistence['metric'],
        arguments: { persistence: 'metric' }
      }
    },{
      title: 'Dynamic Wind Indicators',
      subtitle: 'Updates direction based on compass.',
      accessory: {
        view: :switch,
        action: :switched,
        value: App::Persistence['compass'],
        arguments: { persistence: 'compass' }
      }
    }, {
      title: 'Use Magnetic North',
      subtitle: 'Turning off will use true North.',
      accessory: {
        view: :switch,
        action: :switched,
        value: App::Persistence['magnetic'],
        arguments: { persistence: 'magnetic' }
      }
    }]
  end

  def switched(args = {})
    if args[:persistence] == 'compass' && args[:value] == true && BW::Location.authorized? == false
      App.alert("Location Services\nAre Disabled", {
        message: "Please enable location services for #{App.name} in the settings app in order to use dynamic wind indicators."
      })
    end

    App::Persistence[args[:persistence]] = args[:value] || false

    # Log the change in Flurry
    # flurry_params = {on_off: args[:value]}
    # Flurry.logEvent("#{args[:persistence].upcase}_SWITCH", withParameters:flurry_params) unless Device.simulator?
  end
end
