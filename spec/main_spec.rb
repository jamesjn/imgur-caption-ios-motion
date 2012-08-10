describe "Application 'imgur-caption'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "has one window" do
    @app.windows.size.should == 1
  end
  
  it "has a root view controller of class HomeController" do
     @app.windows.first.rootViewController.class.should == HomeController
  end

end
