//
//  ComposeViewController.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/30/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class ComposeViewController: UIViewController, UITextViewDelegate {

    let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet var initialGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetCharCount: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    
    @IBOutlet weak var tweetActionView: UIView!
    
    var attributeText: NSMutableAttributedString?
    
    var tweets: [Tweet?] = []
    var reply = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setImageWith(URL(string: User.currentUser!.profileImageUrl!)!)
        
        self.automaticallyAdjustsScrollViewInsets = false

        textView.delegate = self
        
        if reply == true {
            let tweet = tweets[0]!
            if tweet.retweetedByHandleString != nil {
                textView.text = "\(tweet.user!.screenname!) \(tweet.retweetedByScreenName!) "
            } else {
                textView.text = "\(tweet.user!.screenname!) "
            }
        }
        
        textView.becomeFirstResponder()
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let status = textView.text!
       
        var in_reply_to = nil as Int?
        if reply == true {
            in_reply_to = tweets[0]!.id
        }
        
        TwitterClient.sharedInstance.composeTweet(status: status, in_reply_to: in_reply_to) { (dictionary, error) in
            if dictionary != nil {
                let tweet = Tweet(dictionary: dictionary!)
                self.tweets.insert(tweet, at: 0)
            } else {
                self.alertController.message = "Error occurred. Please try again."
                self.present(self.alertController, animated: true) {}
            }
        }

        let navigationViewController = segue.destination as! UINavigationController
        let timelineViewController = navigationViewController.topViewController as! TweetsViewController
        timelineViewController.tweets = tweets
    }

    func textViewDidChange(_ textView: UITextView) {
        let length = textView.text.characters.count
        
        if length <= 120 {
            tweetCharCount.text = "\(140-(length))"
        } else {
            let newLength = "\(140-(length))"
            let range = (newLength as NSString!).range(of: newLength as String!)
            self.attributeText = NSMutableAttributedString(string: newLength)
            self.attributeText!.addAttribute(NSForegroundColorAttributeName, value: Helper.sharedInstance.twitterPink(), range: range)
            tweetCharCount.attributedText = self.attributeText!
            
            /* TODO: Add styling for font highlight for errors and other stuff
            if(length > 140) {
                let distance = 140-length
                let index1 = textView.text.index(textView.text.endIndex, offsetBy: distance)
                
                let substring = textView.text.substring(from: index1)
                let highlightRange = (textView.text as NSString!).range(of: substring as String!)
                
                self.attributeText = NSMutableAttributedString(string: textView.text!)
                self.attributeText!.addAttribute(NSBackgroundColorAttributeName, value: Helper.sharedInstance.twitterPink(alpha: CGFloat.init(0.5)), range: highlightRange)
                textView.attributedText = self.attributeText!
            } */
        }
    }
    
    /* 
     
     TODO: For use when dynamic height is introduced.
     
     NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
     NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
     
     NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
     NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
                self.tweetActionView.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
                self.tweetActionView.frame.origin.y += keyboardSize.height
            }
        }
    } */
}
