//
//  DetailViewController.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/28/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdAtString: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var retweetHandleLabel: UILabel!
    @IBOutlet weak var retweetAction: UIImageView!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var mediaImage: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    
    let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
    let paragraphStyle = NSMutableParagraphStyle()
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paragraphStyle.lineSpacing = 3
        
        if tweet != nil {
            let url = URL(string: "\(tweet!.user!.profileImageUrl!)")
            profileImageView.setImageWith(url!)
            userNameLabel.text = tweet!.user!.name
            userHandleLabel.text = tweet!.user!.screenname
            createdAtString.text = tweet!.getCreation()
            
            if tweet?.retweetedByHandleString != nil {
                retweetHandleLabel.text = tweet!.retweetHandle()
                retweetAction.image = UIImage(named: "retweetActionOn")
                headerView.isHidden = false
            } else {
                headerView.isHidden = true
            }
        
            if (tweet?.media_included)! {
                mediaImage.setImageWith(tweet!.mediaImageUrl!)
                mediaView.isHidden = false
            } else {
                mediaView.isHidden = true
            }
            
            tweet!.attributeText?.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, tweet!.attributeText!.length))
            tweetLabel.attributedText = tweet!.attributeText!
            
            retweetCountLabel.text = tweet!.retweetCountString(short: false)!
            likeCountLabel.text = tweet!.favoriteCountString(short: false)!
            
            Helper.sharedInstance.setFavoriteActionButton(favorited: tweet!.favorited, button: favoriteButton)
            Helper.sharedInstance.setRetweetActionButton(retweeted: tweet!.retweeted, button: retweetButton)
            
        } else {
            // TODO: This shouldn't happen but just in case, dismiss modal or something.
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onFavorite(_ sender: AnyObject) {
        if tweet!.favorited == false {
            favoriteButton.setBackgroundImage(UIImage(named: "favoriteActionOn"), for: UIControlState.normal)
            likeCountLabel.text = "\(tweet!.favoriteCount!+1)"
            
            tweet!.favorite(completion: { (newTweet, error) in
                if error != nil {
                    self.favoriteButton.setBackgroundImage(UIImage(named: "favoriteAction"), for: UIControlState.normal)
                    self.likeCountLabel.text = "\(self.tweet!.favoriteCount!)"
                } else {
                    self.tweet!.favorited = true
                    let c = self.tweet!.favoriteCount!
                    self.tweet!.favoriteCount = c+1
                }
            })
        } else {
            favoriteButton.setBackgroundImage(UIImage(named: "favoriteAction"), for: UIControlState.normal)
            likeCountLabel.text = "\(self.tweet!.favoriteCount!-1)"
            
            tweet!.unfavorite(completion: { (newTweet, error) in
                if error != nil {
                    self.favoriteButton.setBackgroundImage(UIImage(named: "favoriteActionOn"), for: UIControlState.normal)
                    self.likeCountLabel.text = "\(self.tweet!.favoriteCount!)"
                } else {
                    self.tweet!.favorited = false
                    let c = self.tweet!.favoriteCount!
                    self.tweet!.favoriteCount = c-1
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let navigationViewController = segue.destination as! UINavigationController
            let composeViewController = navigationViewController.topViewController as!ComposeViewController
            composeViewController.reply = true
            composeViewController.tweets = [tweet]
        
    }
    
    @IBAction func onRetweet(_ sender: AnyObject) {
        if tweet!.retweeted == false {
            retweetButton.setBackgroundImage(UIImage(named: "retweetActionOn"), for: UIControlState.normal)
            retweetCountLabel.text = "\(self.tweet!.retweetCount!+1)"
            
            tweet!.retweet(completion: { (tweet, error) in
                if error != nil {
                    self.retweetButton.setBackgroundImage(UIImage(named: "retweetAction"), for: UIControlState.normal)
                } else {
                    self.tweet!.retweeted = true
                    let c = self.tweet!.retweetCount!
                    self.tweet!.retweetCount = c+1
                }
            })
            
        } else {
            retweetButton.setBackgroundImage(UIImage(named: "retweetAction"), for: UIControlState.normal)
            retweetCountLabel.text = "\(self.tweet!.retweetCount!-1)"
            
            tweet!.unretweet(completion: { (tweet, error) in
                if error != nil {
                    self.retweetButton.setBackgroundImage(UIImage(named: "retweetActionOn"), for: UIControlState.normal)
                } else {
                    self.tweet!.retweeted = false
                    let c = self.tweet!.retweetCount!
                    self.tweet!.retweetCount = c-1
                }
            })
        }
    }

}
