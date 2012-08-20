class HomeController < UIViewController
  attr_accessor :image  
  attr_accessor :image_url
  attr_accessor :activity_indicator

  def init
    self
  end

  def viewWillAppear(animated)
  end

  def viewDidLoad
    view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("brushedmetal.png"))
    @choose_image_label = choose_image_label
    view.addSubview(@choose_image_label)
    @image_view = image_view
    view.addSubview(@image_view) 
    if Device.camera.rear?
      view.addSubview(get_image_camera_button) 
    end
    view.addSubview(get_image_album_button) 
    @set_text_button = set_text_button
    @set_text_button.setHidden(true)
    view.addSubview(@set_text_button) 
    @send_to_imgur_and_email_button = send_to_imgur_and_email_button
    @send_to_imgur_and_email_button.setHidden(true)
    view.addSubview(@send_to_imgur_and_email_button) 
  end

  def pickImage
    BW::Device.camera.any.picture(media_types: [:image]) do |result|
      if(result[:original_image])
        scale_and_set_image_view(result)
        @set_text_button.setHidden(false)
        @choose_image_label.setHidden(true)
        @send_to_imgur_and_email_button.setHidden(false)
      end
    end
  end
  
  def cameraImage
    BW::Device.camera.rear.picture(media_types: [:image]) do |result|
      if(result[:original_image])
        scale_and_set_image_view(result)
        @set_text_button.setHidden(false)
        @choose_image_label.setHidden(true)
        @send_to_imgur_and_email_button.setHidden(false)
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

  def alertForText
    alert = UIAlertView.alloc.initWithTitle("Caption", message:"Please enter your caption", delegate:self, cancelButtonTitle:"Enter", otherButtonTitles:nil)
    alert.alertViewStyle = UIAlertViewStylePlainTextInput
    alertTextField = alert.textFieldAtIndex(0)
    alertTextField.keyboardType = UIKeyboardTypeAlphabet
    alertTextField.placeholder = "Your caption"
    alert.show()
  end

  def alertView(alertView, clickedButtonAtIndex: buttonIndex)
    addTextToImage(alertView.textFieldAtIndex(0).text)
  end

  def addTextToImage(text)
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

    text.drawInRect(CGRectMake(0,height*0.75,width,height/4), withFont:font, lineBreakMode: UILineBreakModeWordWrap, alignment: UITextAlignmentCenter)

    CGContextSetTextDrawingMode(context, KCGTextFill)
    CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor())
    text.drawInRect(CGRectMake(0,height*0.75,width,height/4), withFont:font, lineBreakMode: UILineBreakModeWordWrap, alignment: UITextAlignmentCenter)

    textImage = UIGraphicsGetImageFromCurrentImageContext();
    @captioned_image = textImage
    @image_view.setImage(textImage)
  end

  def add_activity_indicator_and_start
    @activity_indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
    @activity_indicator.frame = [[120,330],[50,50]]
    @activity_indicator 
    view.addSubview(@activity_indicator)
    @activity_indicator.startAnimating
  end

  def uploadAndEmail
    @set_text_button.setHidden(true)
    @send_to_imgur_and_email_button.setHidden(true)
    add_activity_indicator_and_start
    App.run_after(0.5) do
      image_to_upload = @captioned_image ? @captioned_image : @image
      url = ImgurUploader.uploadImage(image_to_upload, self)
    end
  end

  def mailComposeController(controller, didFinishWithResult:result, error:error)
    self.dismissModalViewControllerAnimated(true)
  end

  def open_email(url)
    if(MFMailComposeViewController.canSendMail)
      mailer = MFMailComposeViewController.alloc.init
      mailer.mailComposeDelegate = self
      mailer.setSubject("Email from imgur")
      emailBody = url
      mailer.setMessageBody(emailBody, isHTML:false)
      self.presentModalViewController(mailer, animated:true)
    else
      alert = UIAlertView.alloc.initWithTitle("Failure", message:"Your device can't send me", delegate:nil, cancelButton:"Ok", otherButtonTitles:nil)
      alert.show
    end
  end

  private

  def choose_image_label
    view = UILabel.alloc.init
    view.frame = [[10,10],[300,400]]
    view.text = 'Please choose an image'
    fontSize = 20
    view.font = UIFont.fontWithName("TrebuchetMS", size:fontSize)
    view.textAlignment = UITextAlignmentCenter
    view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("brushedmetal.png"))
    view
  end

  def image_view
    view = UIImageView.alloc.init
    view.frame = [[10,10],[300,400]]
    view.image = @image
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
    button.addTarget(self, action:'cameraImage', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Camera', forState:UIControlStateNormal)
    button
  end

  def set_text_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[130,420],[60,35]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'alertForText', forControlEvents:UIControlEventTouchUpInside)
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
