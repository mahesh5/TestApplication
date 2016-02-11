//
//  ViewController.swift
//  TestApplication
//
//  Created by HIA Apps on 2/11/16.
//  Copyright © 2016 HIA Qatar. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var responseArray:NSMutableArray = []
    @IBOutlet weak var tblFeeds: UITableView!
    @IBOutlet weak var loadingIndicaotor: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Test Application"
        self.loadingIndicaotor.startAnimating()
        let url1 = NSURL(string : "https://www.reddit.com/hot.json")
        let request1 = NSURLRequest(URL: url1!)
        NSURLConnection.sendAsynchronousRequest(request1, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
            do{
                let responseDic = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions (rawValue: 0))
                self.responseArray  = ((responseDic.objectForKey("data")?.valueForKey("children"))!) as! NSMutableArray
                self.tblFeeds.reloadData()
                self.loadingIndicaotor.stopAnimating()
            }
            catch
            {
               print("error")
            }
        }
        
        
    }
    
    
    // tableView Delegate Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellItems", forIndexPath: indexPath)
        let dictionary = self.responseArray[indexPath.row] as? NSDictionary
        let profileImg =  cell.contentView.viewWithTag(1) as! UIImageView
       
        if let url = NSURL(string:(dictionary!["data"]?["thumbnail"] as? String)!)
        {
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    if (data != nil)
                    {
                        profileImg.image = UIImage(data: data!)

                    }else
                    {
                        profileImg.image = UIImage(named: "profileIcon")
                    }
            }
            
        }
        (cell.contentView.viewWithTag(2) as! UILabel).text =  dictionary!["data"]?["title"] as? String
        
        let lblDescription = cell.viewWithTag(3) as! UILabel

        let text = String(format: "%@ %@ %@",
            (dictionary!["data"]?["domain"] as? String)!,(dictionary!["data"]?["author"] as? String)!,(dictionary!["data"]?["subreddit"] as? String)!)
        let linkTextWithColor = (dictionary!["data"]?["domain"] as? String)
        let range = (text as NSString).rangeOfString(linkTextWithColor!)
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 84/255.0, green: 158/255, blue: 193/255.0, alpha: 1) , range: range)
        lblDescription.attributedText = attributedString

        
        
        
        (cell.contentView.viewWithTag(4) as! UILabel).text =  dictionary!["data"]?["score"]!!.description
        
        
        let lblComments = cell.viewWithTag(5) as! UILabel
        lblComments.text =  dictionary!["data"]?["num_comments"]!!.description
        lblComments.layer.borderWidth = 0.9
        lblComments.layer.cornerRadius = 8
        lblComments.textAlignment = NSTextAlignment.Center
        lblComments.layer.borderColor = UIColor.lightGrayColor().CGColor

        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

