class AppDelegate < ProMotion::Delegate

  tint_color UIColor.whiteColor

  attr_accessor :main_screen

  def on_load(app, options)
    # BubbleWrap.usere_weak_callbacks = true

    setup
    appearance

    self.main_screen = WindsScreen.new(nav_bar: true)
    open self.main_screen
    true
  end

  def setup
    BW.debug = true unless App.info_plist['AppStoreRelease'] == true

    if defined? TestFlight
      TestFlight.setDeviceIdentifier UIDevice.currentDevice.uniqueIdentifier
      TestFlight.takeOff "e9a2e874-1b13-426c-ad0f-6958e7b2889c"
    end

    # 3rd Party integrations
    unless Device.simulator?
      app_id = App.info_plist['APP_STORE_ID']

      # Flurry
      NSSetUncaughtExceptionHandler("uncaughtExceptionHandler")
      Flurry.startSession("YSNRBSKM9B3ZZXPG7CG7")

      # Appirater
      Appirater.setAppId app_id
      Appirater.setDaysUntilPrompt 5
      Appirater.setUsesUntilPrompt 10
      Appirater.setTimeBeforeReminding 5
      Appirater.appLaunched true

      # Harpy
      Harpy.sharedInstance.setAppID app_id
      Harpy.sharedInstance.checkVersion
    end
  end

  def app_color
    Color.new("#15adca")
  end

  def appearance
    nav_bar = UINavigationBar.appearance
    nav_bar.setBarStyle UIBarStyleBlack
    nav_bar.setBarTintColor app_color.to_color
    nav_bar.setTintColor UIColor.whiteColor
    nav_bar.setTitleTextAttributes({
    #   UITextAttributeFont => UIFont.fontWithName('Trebuchet MS', size:24),
      # UITextAttributeTextShadowColor => UIColor.colorWithWhite(0.0, alpha:0.4),
      UITextAttributeTextColor => UIColor.whiteColor
    })
  end

  #Flurry exception handler
  def uncaughtExceptionHandler(exception)
    Flurry.logError("Uncaught", message:"Crash!", exception:exception)
  end

  def will_enter_foreground
    Appirater.appEnteredForeground true unless Device.simulator?
  end

end
