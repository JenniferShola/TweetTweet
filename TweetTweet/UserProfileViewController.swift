
//
//  UserProfileViewController.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 11/1/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate  {

    @IBOutlet weak var headerPhoto: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    
    @IBOutlet weak var profileLocationLabel: UILabel!
    @IBOutlet weak var profileUrlLabel: UILabel!
    @IBOutlet weak var profileAgeLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    var user_id: Int?
    var screen_name: String?
    var tweets: [Tweet?] = []
    var isMoreDataLoading = false
    var since_id = 0    // To return results with an ID greater than (more recent than) the specified ID.
    var max_id = 0      // To return results with an ID less than (older than) or equal to the specified ID.
    
    override func viewDidLoad() {
        if user == nil {
            user = User.currentUser
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        resetTweetsToUserTimeline()
        self.tableView.reloadData()
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.userProfileImageView.setImageWith(URL(string: user!.profileImageUrl!)!)
        
        if let header = user!.profileHeaderUrl {
            self.headerPhoto.setImageWith(URL(string: header)!)
            self.headerPhoto.isHidden = false
        } else {
            self.headerPhoto.isHidden = true
        }
        
        if let url = user!.profileHeaderUrl {
            self.profileUrlLabel.text = "\(url)"
            self.profileUrlLabel.isHidden = false
        } else {
            self.profileUrlLabel.isHidden = true
        }
        
        
        self.userNameLabel.text = user!.name
        self.userHandleLabel.text = user!.screenname!
        self.profileDescriptionLabel.text = user!.tagline
        
        self.profileLocationLabel.text = "\(user!.location!)"
        
        self.followersLabel.text = "\(user!.followers!)"
        self.followingLabel.text = "\(user!.following!)"
        
        // Do any additional setup after loading the view.
    }
    
    func resetTweetsToUserTimeline() {
        let keys = ["user_id"]
        let params = NSDictionary.init(objects: [user!.id!], forKeys: keys as [NSCopying])
        TwitterClient.sharedInstance.userTimeline(params: params) { (newTweets, error) in
            if let twits = newTweets {
                self.tweets = twits
                self.tableView.reloadData()
            }
        }
    }
    
    func formatUserParams(name: String?, user_id: Int?) -> NSDictionary{
        let keys = ["screen_name", "user_id"]
        let params = NSDictionary.init(objects: [name!, user_id!], forKeys: keys as [NSCopying])
        return params
    }
    
    
    func formatUserTimelineParams() -> NSDictionary{
        let keys = ["max_id", "id"]
        let params = NSDictionary.init(objects: [max_id, user!.id], forKeys: keys as [NSCopying])
        return params
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height + 20
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                TwitterClient.sharedInstance.userTimeline(params: formatUserTimelineParams()) { (newTweets, error) in
                    if let twits = newTweets {
                        for t in twits {
                            if (t.id != self.max_id) {
                                self.tweets.append(t)
                            }
                        }
                        
                        let length = self.tweets.count
                        self.max_id = (self.tweets[length-1]?.id)!
                        
                        self.isMoreDataLoading = false
                        self.tableView.reloadData()
                    } else {
                        self.isMoreDataLoading = false
                    }
                }
            }
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.userTimeline(params: formatUserTimelineParams()) { (newTweets, error) in
            if let twits = newTweets {
                for t in twits.reversed() {
                    self.tweets.insert(t, at: 0)
                }
                
                self.since_id = (self.tweets[0]?.id)!
                
                self.isMoreDataLoading = false
                self.tableView.reloadData()
            }
            refreshControl.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTweet") as! TimelineTweetCell
        if let tweet = self.tweets[indexPath.row] {
            cell.mediaImageView.image = nil
            if tweet.media_included {
                cell.mediaImageView.setImageWith(tweet.mediaImageUrl!)
                cell.mediaView.isHidden = false
            } else {
                cell.mediaView.isHidden = true
            }
            
            cell.handleLabel.text = "\(tweet.user!.screenname!)"
            cell.profileNameLabel.text = tweet.user!.name!
            cell.tweet = tweet
            
            let favoriteText = tweet.favoriteCountString(short: true)!
            if tweet.favorited == true {
                let attributeText = NSMutableAttributedString(string: favoriteText)
                let range = (favoriteText as NSString!).range(of: favoriteText)
                attributeText.addAttribute(NSForegroundColorAttributeName, value: Helper.sharedInstance.twitterPink(), range: range)
                cell.favoriteCountLabel.attributedText = attributeText
            } else {
                let attributeText = NSMutableAttributedString(string: favoriteText)
                let range = (favoriteText as NSString!).range(of: favoriteText)
                attributeText.addAttribute(NSForegroundColorAttributeName, value: Helper.sharedInstance.twitterGray(), range: range)
                cell.favoriteCountLabel.attributedText = attributeText
            }
            
            let retweetText = tweet.retweetCountString(short: true)!
            if tweet.retweeted == true {
                let attributeText = NSMutableAttributedString(string: retweetText)
                let range = (retweetText as NSString!).range(of: retweetText)
                attributeText.addAttribute(NSForegroundColorAttributeName, value: Helper.sharedInstance.twitterPink(), range: range)
                cell.favoriteCountLabel.attributedText = attributeText
            } else {
                let attributeText = NSMutableAttributedString(string: retweetText)
                let range = (retweetText as NSString!).range(of: retweetText)
                attributeText.addAttribute(NSForegroundColorAttributeName, value: Helper.sharedInstance.twitterGray(), range: range)
                cell.retweetsCountLabel.attributedText = attributeText
            }
            
            //tweet.attributeText!.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range:NSMakeRange(0, tweet.attributeText!.length))
            cell.tweetTextLabel.attributedText = tweet.attributeText!
            
            // TODO: Reorganize body view to allow tweet text to be hidden if needed
            
            if tweet.retweetedByHandleString != nil {
                cell.retweetHandleLabel.text = tweet.retweetHandle()
                cell.retweetImage.image = UIImage(named: "retweetActionOn")
                cell.headerView.isHidden = false
            } else {
                cell.headerView.isHidden = true
            }
            
            Helper.sharedInstance.setFavoriteActionButton(favorited: tweet.favorited, button: cell.favoriteActionButton)
            Helper.sharedInstance.setRetweetActionButton(retweeted: tweet.retweeted, button: cell.retweetActionButton)
            
            cell.timeLabel.text = tweet.getActivitySince()!
            
            let url = URL(string: "\(tweet.user!.profileImageUrl!)")
            cell.profileImageButton.setBackgroundImageFor(UIControlState.normal, with: url!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
