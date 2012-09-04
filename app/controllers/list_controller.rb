class ListController < UITableViewController

  def initWithList(image_list)
    @image_list = image_list
    self.init
  end

  def init
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('Uploaded List', image:UIImage.imageNamed('list_icon.png'), tag:3)
    self
  end

  def viewDidLoad
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    @images_list = @image_list.images || []
    view.reloadData
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @images_list.size
  end

  CellID = 'CellIdentifier'

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    imageItem = @images_list[indexPath.row]
    cell.textLabel.text = imageItem[:original_url]
    cell.image = load_picture_from(imageItem[:small_url])
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    @current_item = @images_list[indexPath.row]
    alert = UIAlertView.alloc.initWithTitle("Choose your option", message:"", delegate:self, cancelButtonTitle:"Cancel", otherButtonTitles:nil)
    alert.addButtonWithTitle("Email Imgur Link")
    alert.show()
  end

  def alertView(alertView, clickedButtonAtIndex:buttonIndex)
    case buttonIndex
    when 0
      alertView.dismissWithClickedButtonIndex(0, animated:false)
    when 1
      alertView.dismissWithClickedButtonIndex(1, animated:false)
      open_email(@current_item[:original_url])
    end
  end

  def open_email(url)
    @url = url
    if(MFMailComposeViewController.canSendMail)
      mailer = MFMailComposeViewController.alloc.init
      mailer.mailComposeDelegate = self
      mailer.setSubject("Email from Imgur Caption")
      emailBody = url
      mailer.setMessageBody(emailBody, isHTML:false)
      self.presentModalViewController(mailer, animated:true)
    else
      alert = UIAlertView.alloc.initWithTitle("Failure", message:"Your device can't send me", delegate:nil, cancelButton:"Ok", otherButtonTitles:nil)
      alert.show
    end
  end

  def mailComposeController(controller, didFinishWithResult:result, error:error)
    self.dismissModalViewControllerAnimated(true)
  end

  private

  def load_picture_from(url)
    url = NSURL.URLWithString(url)
    image = UIImage.imageWithData(NSData.dataWithContentsOfURL(url))
  end
end
