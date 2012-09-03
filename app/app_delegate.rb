class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    tabbar_controller = initialize_tabbar_controller
    window.rootViewController = tabbar_controller
    window.makeKeyAndVisible
  end

  private
  
  def initialize_tabbar_controller
    select_controller = SelectController.alloc.init
    edit_controller   = EditController.alloc.init
    list_controller   = ListController.alloc.init
    tab_controllers = [select_controller, edit_controller, list_controller]
    tabbar_controller = TabbarController.alloc.initWith(tab_controllers)
  end 

end
