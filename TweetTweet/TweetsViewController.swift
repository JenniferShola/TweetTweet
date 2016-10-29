//
//  TweetsViewController.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/27/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var titleView = UIImageView(frame:CGRect(x: 0, y: 0, width: 40, height: 35))
    var tweets: [Tweet?]?
    let paragraphStyle = NSMutableParagraphStyle()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paragraphStyle.lineSpacing = 2.5
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.tableView.reloadData()
        
        titleView.contentMode = .scaleAspectFit
        titleView.image = UIImage(named: "Twitter_Logo_Blue")

        self.navigationItem.titleView = titleView;
        self.navigationController?.navigationBar.sizeToFit()
        
        TwitterClient.sharedInstance.homeTimeline(params: nil) { (tweets, error) in
            self.tweets = tweets
            self.tableView.reloadData()
            //tableview did load 
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! TimelineTweetCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets![(indexPath! as NSIndexPath).row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.tweet = tweet
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline(params: nil) { (tweets, error) in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineTweet") as! TimelineTweetCell
        
        if let tweet = self.tweets?[indexPath.row] {
            cell.profileNameLabel.text = tweet.user!.name!
            cell.handleLabel.text = "@\(tweet.user!.screenname!)"
            cell.timeLabel.text = "34m"
            cell.tweet = tweet
            
            let attrTweetText = NSMutableAttributedString(string: tweet.text!)
            attrTweetText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrTweetText.length))
            cell.tweetTextLabel.attributedText = attrTweetText
            
            if let retweet = tweet.retweetedByHandleString {
                cell.retweetHandleLabel.text = "\(retweet) Retweeted"
                cell.retweetImage.image = UIImage(named: "retweetActionOn")
                cell.headerView.isHidden = false
            } else {
                cell.headerView.isHidden = true
            }
            
            if tweet.retweeted == true {
                setButtonImage(button: cell.retweetActionButton, imageName: "retweetActionOn")
            } else {
                setButtonImage(button: cell.retweetActionButton, imageName: "retweetAction")
            }
            
            if tweet.favorited == true {
                setButtonImage(button: cell.favoriteActionButton, imageName: "favoriteActionOn")
            } else {
                setButtonImage(button: cell.favoriteActionButton, imageName: "favoriteAction")
            }
            
            //cell.timeLabel.text = tweet.createdAtString!
            
            let url = URL(string: "\(tweet.user!.profileImageUrl!)")
            cell.profileImage.setImageWith(url!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func setButtonImage(button: UIButton!, imageName: String!) {
        button.setBackgroundImage(UIImage(named: imageName), for: UIControlState.normal)
    }

    @IBAction func onLogout(_ sender: AnyObject) {
        print("GOT TO LOGOUT")
        print("MY USER's NAME IS \(User.currentUser?.name)")
        User.currentUser?.logout()
    }

}
