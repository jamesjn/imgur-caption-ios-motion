class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    tabbar_controller = initialize_tabbar_controller
    window.rootViewController = tabbar_controller
    window.makeKeyAndVisible
  end

  private
  
  def initialize_tabbar_controller
    @image_list = ImageList.new
    image_list_images = App::Persistence['image_list_images']
    if image_list_images 
      @image_list.images = image_list_images
    end
    select_controller = SelectController.alloc.initWithList(@image_list)
    edit_controller   = EditController.alloc.initWithList(@image_list)
    list_controller   = ListController.alloc.initWithList(@image_list)
    tab_controllers = [select_controller, edit_controller, list_controller]
    tabbar_controller = TabbarController.alloc.initWith(tab_controllers)
  end 

  def applicationDidEnterBackground(app)
    App::Persistence['image_list_images'] = @image_list.images
  end
end
