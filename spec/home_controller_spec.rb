describe "HomeController" do
  tests HomeController
  before do
    @app = UIApplication.sharedApplication
    @subject = @app.windows.first.rootViewController
  end

  it "has background pattern " do
    #TO DO figure out how to check for background patterns
    @subject.view.backgroundColor.class.should == UICGColor 
  end

  it "has an image of nil initially" do
    @subject.image.should == nil
  end 

  it "image_view returns UIImageView" do
    image_view = @subject.send(:image_view)
    image_view.class.should == UIImageView
  end 

  it "has buttons that returns UIRoundedRectButton" do
    button = @subject.send(:get_image_button)
    button.class.should == UIRoundedRectButton 
    button = @subject.send(:set_text_button)
    button.class.should == UIRoundedRectButton 
    button = @subject.send(:send_to_imgur_and_email_button)
    button.class.should == UIRoundedRectButton 
  end 

  it "has a UIImageView subview with no initial image" do
    subview = @subject.view.subviews.first
    subview.class.should == UIImageView
    subview.image.should == nil
  end 
  
  it "has button subviews" do
    subviews = @subject.view.subviews
    button_subviews = subviews.select{|s| s.class == UIRoundedRectButton}
    button_subviews.size.should == 3
    ['Get Image', 'Set Text', 'Imgur and Email'].each do |title|
      label_titles = button_subviews.map(&:titleLabel).map(&:text)
      label_titles.include?(title).should.equal(true)
    end
  end 

  it 'taps the pickImage button' do
    tap 'Get Image'
    tap 'Saved Photos'
    1.should == 1
  end

end
