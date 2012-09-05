class EditController < UIViewController
  attr_accessor :activity_indicator

  def initWithList(image_list)
    @list = image_list
    self.init
  end

  def init
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('Edit Image', image:UIImage.imageNamed('edit_icon.png'), tag:2)
    self
  end

  def viewWillAppear(animated)
    @image_view.image = @list.current_image
    if @list.current_image
      @choose_image_label.setHidden(true)
      @set_text_button.setHidden(false)
      @upload_to_imgur_button.setHidden(false)
      @filter_select_button.setHidden(false)
    else
      @choose_image_label.setHidden(false)
      @set_text_button.setHidden(true)
      @upload_to_imgur_button.setHidden(true)
      @filter_select_button.setHidden(true)
    end

  end

  def viewDidLoad
    view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("brushedmetal.png"))
    @image_view = image_view
    view.addSubview(@image_view) 
    @choose_image_label = choose_image_label
    view.addSubview(@choose_image_label)
    @set_text_button = set_text_button
    @set_text_button.setHidden(true)
    view.addSubview(@set_text_button) 
    @upload_to_imgur_button = upload_to_imgur_button
    @upload_to_imgur_button.setHidden(true)
    view.addSubview(@upload_to_imgur_button) 
    @filter_select_button = filter_select_button
    view.addSubview(@filter_select_button) 
    @filter_select_button.setHidden(true)
  end

  def alertForText
    alert = UIAlertView.alloc.initWithTitle("Caption", message:"Please enter your caption", delegate:self, cancelButtonTitle:"Enter", otherButtonTitles:nil)
    alert.alertViewStyle = UIAlertViewStylePlainTextInput
    alertTextField = alert.textFieldAtIndex(0)
    alertTextField.keyboardType = UIKeyboardTypeAlphabet
    alertTextField.placeholder = "Your caption"
    alert.show()
  end

  def addTextToImage(text)
    myImage = @list.current_image
    height = myImage.size.height
    width = myImage.size.width
    UIGraphicsBeginImageContext(myImage.size)
    context = UIGraphicsGetCurrentContext();
    myImage.drawAtPoint(CGPointZero)
    fontSize = height/20
    font = UIFont.fontWithName("TrebuchetMS", size:fontSize)
    CGContextSetTextDrawingMode(context, KCGTextStroke)
    CGContextSetLineWidth(context, fontSize/18);

    text.drawInRect(CGRectMake(0,height*0.80,width,height/4), withFont:font, lineBreakMode: UILineBreakModeWordWrap, alignment: UITextAlignmentCenter)

    CGContextSetTextDrawingMode(context, KCGTextFill)
    CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor())
    text.drawInRect(CGRectMake(0,height*0.80,width,height/4), withFont:font, lineBreakMode: UILineBreakModeWordWrap, alignment: UITextAlignmentCenter)

    textImage = UIGraphicsGetImageFromCurrentImageContext();
    @image_view.setImage(textImage)
    @list.current_image = textImage
    @upload_to_imgur_button.setHidden(false)
  end

  def uploadToImgur
    @upload_to_imgur_button.setHidden(true)
    add_activity_indicator_and_start
    App.run_after(0.5) do
      image_to_upload = @list.current_image
      ImgurUploader.uploadImage(image_to_upload, @list, self)
    end
  end

  def add_activity_indicator_and_start
    @activity_indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
    @activity_indicator.frame = [[135,330],[50,50]]
    @activity_indicator 
    view.addSubview(@activity_indicator)
    @activity_indicator.startAnimating
  end

  private

  def image_view
    view = UIImageView.alloc.init
    view.frame = [[30,10],[255,340]]
    view.image = @list.current_image
    view
  end

  def set_text_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[125,370],[60,35]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'alertForText', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Add Text', forState:UIControlStateNormal)
    button
  end

  def choose_image_label
    view = UILabel.alloc.init
    view.frame = [[10,10],[300,400]]
    view.text = 'Please select an image first'
    fontSize = 20
    view.font = UIFont.fontWithName("TrebuchetMS", size:fontSize)
    view.textAlignment = UITextAlignmentCenter
    view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("brushedmetal.png"))
    view
  end

  def upload_to_imgur_button
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[200,370],[100,35]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'uploadToImgur', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Upload to Imgur', forState:UIControlStateNormal)
    button
  end

  def chooseFilter
    alert = UIAlertView.alloc.initWithTitle("Choose your filter", message:"", delegate:self, cancelButtonTitle:"Cancel", otherButtonTitles:nil)
    alert.addButtonWithTitle("Hue")
    alert.addButtonWithTitle("Gamma")
    alert.addButtonWithTitle("Invert")
    alert.addButtonWithTitle("Sepia")
    @upload_to_imgur_button.setHidden(false)
    alert.show()
  end

  def alertView(alertView, clickedButtonAtIndex:buttonIndex)
    case buttonIndex
    when 0
      if alertView.title == "Caption"
        addTextToImage(alertView.textFieldAtIndex(0).text)
      end
      alertView.dismissWithClickedButtonIndex(0, animated:false)
    when 1
      alertView.dismissWithClickedButtonIndex(1, animated:false)
      @list.current_image = Filters.filterImageHue(@list.current_image)
      @image_view.image = @list.current_image
    when 2
      alertView.dismissWithClickedButtonIndex(1, animated:false)
      @list.current_image = Filters.filterImageGamma(@list.current_image)
      @image_view.image = @list.current_image
    when 3
      alertView.dismissWithClickedButtonIndex(1, animated:false)
      @list.current_image = Filters.filterImageInvert(@list.current_image)
      @image_view.image = @list.current_image
    when 4
      alertView.dismissWithClickedButtonIndex(1, animated:false)
      @list.current_image = Filters.filterImageSephia(@list.current_image)
      @image_view.image = @list.current_image
    end
  end

  def filter_select_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[10,370],[100,35]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'chooseFilter', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Choose Filter', forState:UIControlStateNormal)
    button
  end
end
