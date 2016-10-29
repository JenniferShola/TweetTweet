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

    @IBOutlet weak var headerView: UIView!
    
    
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
            //increament count label
            
            tweet.favorite(completion: { (tweet, error) in
                if error != nil {
                    self.favoriteActionButton.setBackgroundImage(UIImage(named: "favoriteAction"), for: UIControlState.normal)
                    //decrease count
                }
            })
        } else {
            //add animation
            favoriteActionButton.setBackgroundImage(UIImage(named: "favoriteAction"), for: UIControlState.normal)
            //decrease count label
            
            tweet.unfavorite(completion: { (tweet, error) in
                if error != nil {
                    self.favoriteActionButton.setBackgroundImage(UIImage(named: "favoriteActionOn"), for: UIControlState.normal)
                }
            })

        }
    }
    
    @IBAction func onRetweet(_ sender: AnyObject) {
        if tweet.retweeted == false {
            //add animation
            retweetActionButton.setBackgroundImage(UIImage(named: "retweetActionOn"), for: UIControlState.normal)
            //increament count label
            
            tweet.retweet(completion: { (tweet, error) in
                if error != nil {
                    self.retweetActionButton.setBackgroundImage(UIImage(named: "retweetAction"), for: UIControlState.normal)
                }
            })
            
        } else {
            //add animation
            retweetActionButton.setBackgroundImage(UIImage(named: "retweetAction"), for: UIControlState.normal)
            //decrease count label
            
            tweet.unretweet(completion: { (tweet, error) in
                if error != nil {
                    self.retweetActionButton.setBackgroundImage(UIImage(named: "retweetActionOn"), for: UIControlState.normal)
                }
            })
        }
        
    }
}
