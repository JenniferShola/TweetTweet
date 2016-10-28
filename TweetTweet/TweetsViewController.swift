//
//  TweetsViewController.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/27/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let twitterLogo = UIImageView.init(image: #imageLiteral(resourceName: "Twitter_Logo_Blue"))
    var tweets: [Tweet?]?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        self.tableView.reloadData()

        
        //self.navigationItem.titleView = twitterLogo;
        self.navigationController?.navigationItem.titleView = twitterLogo;
        self.navigationController?.navigationBar.sizeToFit()
        
        TwitterClient.sharedInstance.homeTimeline(params: nil) { (tweets, error) in
            self.tweets = tweets
            self.tableView.reloadData()
            //tableview did load 
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineTweet") as! TimelineTweetCell
        
        if let tweet = self.tweets?[indexPath.row] {
            cell.profileNameLabel.text = tweet.user!.name!
            cell.handleLabel.text = "@\(tweet.user!.screenname!)"
            cell.tweetTextLabel.text = tweet.text!
            cell.timeLabel.text = "34m"
            //cell.timeLabel.text = tweet.createdAtString!
            
            let url = URL(string: "\(tweet.user!.profileImageUrl!)")
            cell.profileImage.setImageWith(url!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }

    @IBAction func onLogout(_ sender: AnyObject) {
        print("GOT TO LOGOUT")
        print("MY USER's NAME IS \(User.currentUser?.name)")
        User.currentUser?.logout()
    }

}
