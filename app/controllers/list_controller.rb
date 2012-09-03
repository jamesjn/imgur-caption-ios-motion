class ListController < UIViewController
  def init
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('List', image:UIImage.imageNamed('list_icon.png'), tag:3)
    self
  end
end
