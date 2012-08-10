class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    home_controller = HomeController.alloc.init
    window.rootViewController = home_controller
    window.makeKeyAndVisible
  end
end
