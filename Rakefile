# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'rubygems'
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'aloft'

  app.sdk_version = "8.1"
  app.deployment_target = '7.1'

  app.version = (`git rev-list HEAD --count`.strip.to_i).to_s
  app.short_version = '1.0.4b2'

  app.device_family = [:iphone]
  app.interface_orientations = [:portrait, :portrait_upside_down]
  app.identifier = 'com.mohawkapps.aloft'
  app.seed_id = 'DW9QQZR4ZL'
  app.icons = Dir.glob("resources/Icon*.png").map{|icon| icon.split("/").last}
  app.prerendered_icon = true
  app.info_plist['APP_STORE_ID'] = 823834093
  app.info_plist['UIRequiredDeviceCapabilities'] = {
    'location-services' => true,
    'magnetometer' => true
  }
  app.info_plist['NSLocationWhenInUseUsageDescription'] = 'We use your location to find NOAA weather stations near you.'
  app.info_plist['NSLocationAlwaysUsageDescription'] = 'We use your location to find NOAA weather stations near you.'
  app.info_plist["UIViewControllerBasedStatusBarAppearance"] = false
  app.info_plist["UIStatusBarStyle"] = "UIStatusBarStyleLightContent"

  app.entitlements['get-task-allow'] = true
  app.codesign_certificate = "iPhone Developer: Mark Rickert (YA2VZGDX4S)"
  app.provisioning_profile = "./provisioning/development.mobileprovision"

  app.pods do
    pod 'Appirater'
    pod 'Harpy'
  end

  app.release do
    app.info_plist['AppStoreRelease'] = true
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/release.mobileprovision"
  end
end
