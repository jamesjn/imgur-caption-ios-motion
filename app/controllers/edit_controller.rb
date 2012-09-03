class EditController < UIViewController

  def init
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('Edit', image:UIImage.imageNamed('edit_icon.png'), tag:2)
    self
  end

  def viewWillAppear(animated)
  end

  def viewDidLoad

  end

end
