# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bubble-wrap/core'
require 'bubble-wrap/location'
require 'bubble-wrap/http'
require 'bubble-wrap/camera'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Imgur Caption'
  app.version = "1.0"
  app.deployment_target = '5.1'
  app.identifier = "com.jamesjn.imgurcaption"
  app.device_family = :iphone
  app.icons = ["Icon.png", "Icon@2x.png", "Default.png"]
  app.frameworks += ['MessageUI']
  app.device_family = [:iphone]
  app.provisioning_profile = '/Users/jc582/Library/MobileDevice/Provisioning Profiles/0A8F5610-9D45-4021-BC39-9EAC85E48448.mobileprovision'
  app.codesign_certificate = 'iPhone Distribution: James Chiang'
end
