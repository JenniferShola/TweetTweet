//
//  MentionsViewController.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 11/6/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.tableView.reloadData()

        TwitterClient.sharedInstance.mentionsTimeline(params: nil) { (tweets, error) in
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionCell") as! MentionCell
        
        let tweet = tweets?[indexPath.row]
        cell.userNameLabel.text = tweet?.user?.name!
        cell.userHandleLabel.text = tweet?.user?.screenname!
        cell.mentionDateLabel.text = tweet?.getShortCreation()
        cell.mentionTextLabel.text = tweet?.text!
        cell.retweetCount.text = "\(tweet!.retweetCount!)"
        cell.favoriteCount.text = "\(tweet!.favoriteCount!)"
        
        let url = URL(string: "\(tweet!.user!.profileImageUrl!)")
        cell.userImageButton.setBackgroundImageFor(UIControlState.normal, with: url!)
        
        if tweet?.reply_to != nil {
            cell.replyToLabel.text = "In reply to \(tweet!.reply_to_name!)"
        } else {
            //hide label
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    @IBAction func onLogout(_ sender: AnyObject) {
        User.currentUser?.logout()
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
