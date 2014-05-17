class AboutScreen < Formotion::FormController
  include BW::KVO

  def init
    @form ||= Formotion::Form.new({
      sections: [{
        title: 'Settings:',
        rows: [{
          title: 'Use Metric Units',
          subtitle: 'You can also tap altitudes to change this.',
          type: :switch,
          value: App::Persistence['metric']
        }, {
          title: 'Dynamic Wind Indicators',
          subtitle: 'Updates direction based on compass.',
          type: :switch,
          value: App::Persistence['compass']
        }]
      },{
        title: 'Share With Your friends:',
        rows: [{
          title: 'Share the app',
          subtitle: 'Text, Email, Tweet, or Facebook!',
          type: :share,
          image: 'share',
          value: {
            items: "I'm using the '#{App.name}' app to check NOAA winds aloft forecasts. Check it out! http://www.mohawkapps.com/app/aloft/",
            excluded: excluded_services
          }
        }, {
          title: "Rate #{App.name} on iTunes",
          type: :rate_itunes,
          image: 'itunes'
        }]
      }, {
        title: "#{App.name} is open source:",
        rows: [{
          title: 'View on GitHub',
          type: :github_link,
          image: 'github',
          warn: true,
          value: 'https://github.com/MohawkApps/aloft'
        }, {
          title: 'Found a bug?',
          subtitle: 'Log it here.',
          type: :issue_link,
          image: 'issue',
          warn: true,
          value: 'https://github.com/MohawkApps/aloft/issues/'
        }, {
          title: 'Email me suggestions!',
          subtitle: 'I\'d love to hear from you',
          type: :email_me,
          image: 'email',
          value: {
            to: 'mark@mohawkapps.com',
            subject: "#{App.name} App Feedback"
          }
        }]
      }, {
        title: "About #{App.name}:",
        rows: [{
          title: 'Version',
          type: :static,
          placeholder: App.info_plist['CFBundleShortVersionString'],
          selection_style: :none
        }, {
          title: 'Copyright',
          type: :static,
          font: { name: 'HelveticaNeue', size: 14 },
          placeholder: '© 2014, Mohawk Apps, LLC',
          selection_style: :none
        }, {
          title: 'Visit MohawkApps.com',
          type: :web_link,
          warn: true,
          value: 'http://www.mohawkapps.com'
        }, {
          title: 'Made with ♥ in North Carolina',
          type: :static,
          enabled: false,
          selection_style: :none,
          text_alignment: NSTextAlignmentCenter
        }, {
          type: :static_image,
          value: 'nc',
          enabled: false,
          selection_style: :none
        }]
      }, {
        title: "Data Source:",
        rows: [{
          title: 'Forecast Data from NOAA',
          subtitle: '',
          type: :web_link,
          warn: true,
          text_alignment: NSTextAlignmentCenter,
          value: 'http://aviationweather.gov/products/nws/all'
        }, {
          type: :static_image,
          value: 'noaa',
          enabled: false,
          row_height: 150,
          selection_style: :none
        }, {
          type: :text,
          row_height: 60,
          font: { name: 'HelveticaNeue', size: 12 },
          placeholder: 'Logo used with permission. Use of the NOAA logo does not imply endorsement of this app.',
          enabled: false,
          selection_style: :none
        }]
      }]
    })
    Flurry.logEvent("VIEWED_ABOUT") unless Device.simulator?
    super.initWithForm(@form)
  end

  def viewDidLoad
    super
    self.title = 'Settings'
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemStop, target:self, action:'close')
    observe_switces
  end

  def close
    dismissModalViewControllerAnimated(true)
  end

  def excluded_services
    [
      UIActivityTypeAddToReadingList,
      UIActivityTypeAirDrop,
      UIActivityTypeCopyToPasteboard,
      UIActivityTypePrint
    ]
  end

  def observe_switces
    metric = @form.sections[0].rows[0]
    compass = @form.sections[0].rows[1]

    observe(metric, 'value') do |old_value, new_value|
      flurry_params = {on_off: new_value}
      Flurry.logEvent("METRIC_SWITCH", withParameters:flurry_params) unless Device.simulator?
      App::Persistence['metric'] = new_value
    end

    observe(compass, 'value') do |old_value, new_value|
      enabled = BW::Location.enabled?

      if new_value == true && enabled == false
        App.alert("Location Services\nAre Disabled", {
          message: "Please enable location services for #{App.name} in the settings app in order to use dynamic wind indicators."
        })
      end

      flurry_params = { on_off: new_value, location_enabled: enabled }
      Flurry.logEvent("COMPASS_SWITCH", withParameters:flurry_params) unless Device.simulator?
      App::Persistence['compass'] = new_value
    end
  end

end
