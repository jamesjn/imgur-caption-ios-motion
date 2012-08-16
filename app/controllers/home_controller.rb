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
    if Device.camera.rear?
      view.addSubview(get_image_camera_button) 
    end
    view.addSubview(get_image_album_button) 
  end

  def pickImage
    if Device.camera.rear?
      BW::Device.camera.rear.picture(media_types: [:image]) do |result|
        view.addSubview(set_text_button) 
        view.addSubview(send_to_imgur_and_email_button) 
        scale_and_set_image_view(result)
      end
    else
      BW::Device.camera.any.picture(media_types: [:image]) do |result|
        view.addSubview(set_text_button) 
        view.addSubview(send_to_imgur_and_email_button) 
        scale_and_set_image_view(result)
      end
    end
  end

  def scale_and_set_image_view(result)
    @image = result[:original_image]      
    smaller_image = scaleToSize(@image, [480,640])
    @image_view.setImage(smaller_image)
    @image = smaller_image
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
    height = myImage.size.height
    width = myImage.size.width
    UIGraphicsBeginImageContext(myImage.size)
    context = UIGraphicsGetCurrentContext();
    myImage.drawAtPoint(CGPointZero)
    fontSize = height/20
    font = UIFont.fontWithName("TrebuchetMS", size:fontSize)
    CGContextSetTextDrawingMode(context, KCGTextStroke)
    CGContextSetLineWidth(context, fontSize/18);

    "Watermark is good and i hope there is more than enough space for two lines".drawInRect(CGRectMake(0,height*0.75,width,height/4), withFont:font, lineBreakMode: UILineBreakModeWordWrap, alignment: UITextAlignmentCenter)

    CGContextSetTextDrawingMode(context, KCGTextFill)
    CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor())
    "Watermark is good and i hope there is more than enough space for two lines".drawInRect(CGRectMake(0,height*0.75,width,height/4), withFont:font, lineBreakMode: UILineBreakModeWordWrap, alignment: UITextAlignmentCenter)

    textImage = UIGraphicsGetImageFromCurrentImageContext();
    @image = textImage
    @image_view.setImage(textImage)
  end

  def uploadAndEmail
    url = ImgurUploader.uploadImage(@image)
  end

  private

  def image_view
    view = UIImageView.alloc.init
    view.frame = [[10,10],[300,400]]
    view.image = @image
    view.backgroundColor = UIColor.redColor
    view
  end

  def get_image_album_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[10,420],[50,35]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'pickImage', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Album', forState:UIControlStateNormal)
    button
  end

  def get_image_camera_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[70,420],[50,35]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'pickImage', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Camera', forState:UIControlStateNormal)
    button
  end

  def set_text_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[130,420],[60,35]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'addTextToImage', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Set Text', forState:UIControlStateNormal)
    button
  end

  def send_to_imgur_and_email_button
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[200,420],[100,35]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'uploadAndEmail', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Imgur and Email', forState:UIControlStateNormal)
    button
  end

end
