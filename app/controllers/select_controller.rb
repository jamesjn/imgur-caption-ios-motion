class SelectController < UIViewController
  attr_accessor :image_url
  attr_accessor :activity_indicator

  def initWithList(image_list)
    @list = image_list
    self.init
  end

  def init
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('Select Image', image:UIImage.imageNamed('camera_icon.png'), tag:2)
    self
  end

  def viewWillAppear(animated)
    if @list.current_image 
      @image_view.image = @list.current_image
      @choose_image_label.setHidden(true)
    else
      @choose_image_label.setHidden(false)
    end
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
    @upload_to_imgur_button = upload_to_imgur_button
    @upload_to_imgur_button.setHidden(true)
    view.addSubview(@upload_to_imgur_button) 
  end

  def pickImage
    BW::Device.camera.any.picture(media_types: [:image]) do |result|
      if(result[:original_image])
        scale_and_set_image_view(result)
        @choose_image_label.setHidden(true)
        @upload_to_imgur_button.setHidden(false)
        @list.uploaded_picture = false
        @upload_to_imgur_button.setTitle('Upload to Imgur', forState:UIControlStateNormal)
      end
    end
  end
  
  def cameraImage
    BW::Device.camera.rear.picture(media_types: [:image]) do |result|
      if(result[:original_image])
        scale_and_set_image_view(result)
        @choose_image_label.setHidden(true)
        @upload_to_imgur_button.setHidden(false)
        @list.uploaded_picture = false
        @upload_to_imgur_button.setTitle('Upload to Imgur', forState:UIControlStateNormal)
      end
    end
  end

  def scale_and_set_image_view(result)
    @captioned_image = nil
    image = result[:original_image]      
    smaller_image = scaleToSize(image, [480,640])
    @image_view.setImage(smaller_image)
    @list.current_image = smaller_image
    @list.current_orig_image = smaller_image
    dismissModalViewControllerAnimated(true)
  end

  def scaleToSize(image, size)
    UIGraphicsBeginImageContext(size)
    image.drawInRect([[0,0],size])
    scaledImage =  UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    scaledImage
  end

  def add_activity_indicator_and_start
    @activity_indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
    @activity_indicator.frame = [[135,330],[50,50]]
    @activity_indicator 
    view.addSubview(@activity_indicator)
    @activity_indicator.startAnimating
  end

  def uploadToImgur
    @upload_to_imgur_button.setHidden(true)
    add_activity_indicator_and_start
    App.run_after(0.5) do
      image_to_upload = @captioned_image ? @captioned_image : @list.current_image
      ImgurUploader.uploadImage(image_to_upload, @list, self)
      @list.uploaded_picture = true
    end
  end

  private

  def choose_image_label
    view = UILabel.alloc.init
    view.frame = [[10,10],[300,400]]
    view.text = 'Please select an image'
    fontSize = 20
    view.font = UIFont.fontWithName("TrebuchetMS", size:fontSize)
    view.textAlignment = UITextAlignmentCenter
    view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("brushedmetal.png"))
    view
  end

  def image_view
    view = UIImageView.alloc.init
    view.frame = [[30,10],[255,340]]
    view.image = @list.current_image
    view
  end

  def get_image_album_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[10,370],[50,35]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'pickImage', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Album', forState:UIControlStateNormal)
    button
  end

  def get_image_camera_button 
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[70,370],[50,35]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'cameraImage', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Camera', forState:UIControlStateNormal)
    button
  end

  def upload_to_imgur_button
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = [[200,370],[100,35]]
    button.font = UIFont.systemFontOfSize(10)
    button.addTarget(self, action:'uploadToImgur', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle('Upload to Imgur', forState:UIControlStateNormal)
    button
  end

end
