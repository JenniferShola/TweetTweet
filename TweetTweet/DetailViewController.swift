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
    
    @IBOutlet weak var retweetHandleLabel: UILabel!
    @IBOutlet weak var retweetAction: UIImageView!
    
    @IBOutlet weak var likeActionImage: UIImageView!
    @IBOutlet weak var retweetActionImage: UIImageView!
    @IBOutlet weak var replyActionImage: UIImageView!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
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
            createdAtString.text = tweet!.createdAtString
            
            if let retweet = tweet?.retweetedByHandleString {
                retweetHandleLabel.text = "\(retweet) Retweeted"
                retweetAction.image = UIImage(named: "retweetActionOn")
            } else {
                retweetHandleLabel.text = "No Retweeted"
                retweetAction.image = UIImage(named: "retweetAction")
            }
            
            let attrTweetText = NSMutableAttributedString(string: tweet!.text!)
            attrTweetText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrTweetText.length))
            tweetLabel.attributedText = attrTweetText
            
            retweetCountLabel.text = "\(tweet!.retweetCount!)"
            likeCountLabel.text = "\(tweet!.favoriteCount!)"
            
        } else {
            // go back to timeline
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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