//
//  TimelineTweetCell.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/27/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class TimelineTweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetHandleLabel: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    
    @IBOutlet weak var replyActionImage: UIImageView!
    @IBOutlet weak var retweetActionButton: UIButton!
    @IBOutlet weak var favoriteActionButton: UIButton!

    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onFavorite(_ sender: AnyObject) {
        if tweet.favorited == false {
            //add animation
            favoriteActionButton.setBackgroundImage(UIImage(named: "favoriteActionOn"), for: UIControlState.normal)
            favoriteCountLabel.text = "\(tweet.favoriteCount!+1)"
            
            tweet.favorite(completion: { (newTweet, error) in
                if error != nil {
                    self.favoriteActionButton.setBackgroundImage(UIImage(named: "favoriteAction"), for: UIControlState.normal)
                    self.favoriteCountLabel.text = "\(self.tweet.favoriteCount!)"
                } else {
                    self.tweet.favorited = true
                    let c = self.tweet.favoriteCount!
                    self.tweet.favoriteCount = c+1
                }
            })
        } else {
            //add animation
            favoriteActionButton.setBackgroundImage(UIImage(named: "favoriteAction"), for: UIControlState.normal)
            favoriteCountLabel.text = "\(self.tweet.favoriteCount!-1)"
            
            tweet.unfavorite(completion: { (newTweet, error) in
                if error != nil {
                    self.favoriteActionButton.setBackgroundImage(UIImage(named: "favoriteActionOn"), for: UIControlState.normal)
                    self.favoriteCountLabel.text = "\(self.tweet.favoriteCount!)"
                } else {
                    self.tweet.favorited = false
                    let c = self.tweet.favoriteCount!
                    self.tweet.favoriteCount = c-1
                }
            })
        }
    }
    
    @IBAction func onRetweet(_ sender: AnyObject) {
        if tweet.retweeted == false {
            //add animation
            retweetActionButton.setBackgroundImage(UIImage(named: "retweetActionOn"), for: UIControlState.normal)
            retweetsCountLabel.text = "\(self.tweet.retweetCount!+1)"
            
            tweet.retweet(completion: { (tweet, error) in
                if error != nil {
                    self.retweetActionButton.setBackgroundImage(UIImage(named: "retweetAction"), for: UIControlState.normal)
                } else {
                    self.tweet.retweeted = true
                    let c = self.tweet.retweetCount!
                    self.tweet.retweetCount = c+1
                }
            })
            
        } else {
            //add animation
            retweetActionButton.setBackgroundImage(UIImage(named: "retweetAction"), for: UIControlState.normal)
            retweetsCountLabel.text = "\(self.tweet.retweetCount!-1)"
            
            tweet.unretweet(completion: { (tweet, error) in
                if error != nil {
                    self.retweetActionButton.setBackgroundImage(UIImage(named: "retweetActionOn"), for: UIControlState.normal)
                } else {
                    self.tweet.retweeted = false
                    let c = self.tweet.retweetCount!
                    self.tweet.retweetCount = c-1
                }
            })
        }
    }
}
