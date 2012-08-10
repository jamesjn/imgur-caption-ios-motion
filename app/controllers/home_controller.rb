class HomeController < UIViewController
  attr_accessor :image  

  def init
    self
  end

  def viewWillAppear(animated)
  end

  def viewDidLoad
    view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("brushedmetal.png"))
    view.addSubview(image_view) 
    view.addSubview(get_image_button) 
    view.addSubview(set_text_button) 
  end

  private

  def image_view
    view = UIImageView.alloc.init
    view.frame = [[10,10],[300,380]]
    view.backgroundColor = UIColor.redColor
    view
  end

  def get_image_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[20,400],[100,40]]
    button.setTitle('Get Image', forState:UIControlStateNormal)
    button
  end

  def set_text_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[140,400],[100,40]]
    button.setTitle('Set Text', forState:UIControlStateNormal)
    button
  end

end
