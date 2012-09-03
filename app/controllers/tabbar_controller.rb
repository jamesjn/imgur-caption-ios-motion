class TabbarController < UITabBarController

  def initWith(controllers)
    self.init
    self.viewControllers = controllers
    self.tabBar.setBackgroundImage(UIImage.imageNamed("tabbar-bg.png"))
    self.tabBar.setSelectionIndicatorImage(UIImage.imageNamed("tabbar-selection.png").resizableImageWithCapInsets(UIEdgeInsetsMake(12,12,12,12)))
    self
  end
end
