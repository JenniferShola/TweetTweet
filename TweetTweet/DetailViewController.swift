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
            
        } else {
            // TODO: This shouldn't happen but just in case, dismiss modal or something.
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
