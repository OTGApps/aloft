class AppDelegate < ProMotion::Delegate
  tint_color UIColor.whiteColor
  attr_accessor :main_screen

  def on_load(app, options)
    setup
    defaults
    appearance

    self.main_screen = WindsScreen.new(nav_bar: true)
    open self.main_screen
  end

  def setup
    BW.debug = true unless App.info_plist['AppStoreRelease'] == true

    # 3rd Party integrations
    # Only do this on the device
    if !Device.simulator?
      app_id = App.info_plist['APP_STORE_ID']

      # Flurry
      NSSetUncaughtExceptionHandler("uncaughtExceptionHandler")
      Flurry.startSession("2ST55ZW4W4RT2X8X6WWQ")

      # Appirater
      Appirater.setAppId app_id
      Appirater.setDaysUntilPrompt 5
      Appirater.setUsesUntilPrompt 10
      Appirater.setTimeBeforeReminding 10
      Appirater.appLaunched true

      # Harpy
      Harpy.sharedInstance.setAppID app_id
      Harpy.sharedInstance.checkVersion
    end
  end

  def defaults
    App::Persistence['compass'] = true if App::Persistence['compass'].nil?
    App::Persistence['metric']  = false if App::Persistence['metric'].nil?
  end

  def appearance
    nav_bar = UINavigationBar.appearance
    nav_bar.setBarStyle UIBarStyleBlack
    nav_bar.setBarTintColor "#15adca".to_color
    nav_bar.setTintColor UIColor.whiteColor
    nav_bar.setTitleTextAttributes({
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
