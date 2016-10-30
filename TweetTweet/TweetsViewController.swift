//
//  TweetsViewController.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/27/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate  {

    var titleView = UIImageView(frame:CGRect(x: 0, y: 0, width: 45, height: 40))
    var rightBarView = UIImageView(frame:CGRect(x: 0, y: 0, width: 40, height: 34))
    let paragraphStyle = NSMutableParagraphStyle()
    var isMoreDataLoading = false
    var tweets: [Tweet?]?
    var since_id = 0    // To return results with an ID greater than (more recent than) the specified ID.
    var max_id = 0      // To return results with an ID less than (older than) or equal to the specified ID.
    
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
        
        rightBarView.contentMode = .scaleAspectFit
        rightBarView.image = UIImage(named: "composeIcon")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "logoutIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onLogout))
        
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.sizeToFit()
        
        TwitterClient.sharedInstance.homeTimeline(params: nil) { (tweets, error) in
            let length = tweets?.count ?? 0
            
            self.tweets = tweets
            self.tableView.reloadData()
            
            if length == 1 {
                self.since_id = (self.tweets?[0]!.id)!
                self.max_id = (self.tweets![0]!.id)!
            } else if length > 1 {
                self.since_id = (self.tweets?[0]!.id)!
                self.max_id = (self.tweets![length-1]!.id)!
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height + 20
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                TwitterClient.sharedInstance.homeTimeline(params: formatTimelineParams(key: "max_id", value: max_id)) { (newTweets, error) in
                    if let twits = newTweets {
                        for t in twits {
                            self.tweets!.append(t)
                        }
                        
                        let length = self.tweets?.count ?? 0
                        self.max_id = (self.tweets![length-1]?.id)!
                        
                        self.isMoreDataLoading = false
                        self.tableView.reloadData()
                    } else {
                        self.isMoreDataLoading = false
                    }
                }
            }
        }
    }
    
    func formatTimelineParams(key: String?, value: Int?) -> NSDictionary{
        let keys = [key!]
        let params = NSDictionary.init(objects: [value!], forKeys: keys as [NSCopying])
        return params
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! TimelineTweetCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets![(indexPath! as NSIndexPath).row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.tweet = tweet
    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline(params: formatTimelineParams(key: "since_id", value: since_id)) { (newTweets, error) in
            if let twits = newTweets {
                for t in twits.reversed() {
                    self.tweets!.insert(t, at: 0)
                }
                
                self.since_id = (self.tweets![0]?.id)!
                
                self.isMoreDataLoading = false
                self.tableView.reloadData()
            }
            refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineTweet") as! TimelineTweetCell
        
        if let tweet = self.tweets?[indexPath.row] {
            cell.handleLabel.text = "\(tweet.user!.screenname!)"
            cell.profileNameLabel.text = tweet.user!.name!
            cell.tweet = tweet
            
            cell.favoriteCountLabel.text = "\(tweet.favoriteCount!)"
            cell.retweetsCountLabel.text = "\(tweet.retweetCount!)"
            
            let attrTweetText = NSMutableAttributedString(string: tweet.text!)
            attrTweetText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrTweetText.length))
            cell.tweetTextLabel.attributedText = attrTweetText
            
            if tweet.retweetedByHandleString != nil {
                cell.retweetHandleLabel.text = tweet.getRetweetHandleTitle()
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
            
            if tweet.media_included {
                cell.mediaImageView.setImageWith(tweet.mediaImageUrl!)
                cell.mediaView.isHidden = false
            } else {
                cell.mediaView.isHidden = true
            }
            
            cell.timeLabel.text = tweet.getActivitySince()!
            
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
        User.currentUser?.logout()
    }

}
