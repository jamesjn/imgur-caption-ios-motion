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
    imagePicker = UIImagePickerController.alloc.init
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera)
      imagePicker.setSourceType(UIImagePickerControllerSourceTypeCamera)
    else
      imagePicker.setSourceType(UIImagePickerControllerSourceTypePhotoLibrary)
    end

    imagePicker.mediaTypes = [KUTTypeImage]
    imagePicker.delegate = self
    presentModalViewController(imagePicker, animated:true)
  end

  def scaleToSize(image, size)
    UIGraphicsBeginImageContext(size)
    image.drawInRect([[0,0],size])
    scaledImage =  UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    scaledImage
  end

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info)
    image = info.objectForKey(UIImagePickerControllerOriginalImage)
    smaller_image = scaleToSize(image, [480,640])
    @image_view.setImage(image)
    dismissModalViewControllerAnimated(true)
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
