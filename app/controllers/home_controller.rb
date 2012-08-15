class HomeController < UIViewController
  attr_accessor :image  

  def init
    self
  end

  def viewWillAppear(animated)
  end

  def viewDidLoad
    view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("brushedmetal.png"))
    @image_view = image_view
    view.addSubview(@image_view) 
    view.addSubview(get_image_button) 
    view.addSubview(set_text_button) 
    view.addSubview(send_to_imgur_and_email_button) 
  end

  def pickImage
    if Device.camera.rear?
      BW::Device.camera.rear.picture(media_types: [:image]) do |result|
        scale_and_set_image_view(result)
      end
    else
      BW::Device.camera.any.picture(media_types: [:image]) do |result|
        scale_and_set_image_view(result)
      end
    end
  end

  def scale_and_set_image_view(result)
    @image = result[:original_image]      
    smaller_image = scaleToSize(@image, [480,640])
    @image_view.setImage(@image)
    dismissModalViewControllerAnimated(true)
  end

  def scaleToSize(image, size)
    UIGraphicsBeginImageContext(size)
    image.drawInRect([[0,0],size])
    scaledImage =  UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    scaledImage
  end

  def addTextToImage
    myImage = @image 
    UIGraphicsBeginImageContext(myImage.size)
    context = UIGraphicsGetCurrentContext();
    myImage.drawAtPoint(CGPointZero)
    fontSize = 30.0
    font = UIFont.fontWithName("Helvetica-Bold", size:fontSize)
    CGContextSetTextDrawingMode(context, KCGTextStroke)
    CGContextSetLineWidth(context, fontSize/18);

    "Watermark".drawAtPoint(CGPointMake(10,10), withFont:font)

    CGContextSetTextDrawingMode(context, KCGTextFill)
    CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor())
    "Watermark".drawAtPoint(CGPointMake(10,10), withFont:font)

    textImage = UIGraphicsGetImageFromCurrentImageContext();
    @image_view.setImage(textImage)
  end
                  

  private

  def image_view
    view = UIImageView.alloc.init
    view.frame = [[10,10],[300,370]]
    view.image = @image
    view.backgroundColor = UIColor.redColor
    view
  end

  def get_image_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[20,400],[75,40]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'pickImage', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Get Image', forState:UIControlStateNormal)
    button
  end

  def set_text_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[105,400],[75,40]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'addTextToImage', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Set Text', forState:UIControlStateNormal)
    button
  end

  def send_to_imgur_and_email_button
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[190,400],[100,40]]
    button.font = UIFont.systemFontOfSize(10)
    button.setTitle('Imgur and Email', forState:UIControlStateNormal)
    button
  end

end
