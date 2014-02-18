# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Aloft'

  app.pods do
    pod 'FlurrySDK'
    pod 'Appirater'
    pod 'Harpy'
    pod 'TestFlightSDK'
  end
end
