describe "HomeController" do
  before do
    @app = UIApplication.sharedApplication
    @subject = @app.windows.first.rootViewController
  end

  it "has a blue background" do
    @subject.view.backgroundColor.should == UIColor.blueColor
  end

end
