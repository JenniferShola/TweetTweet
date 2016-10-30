//
//  Tweet.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/27/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    
    var id: Int?
    var id_str: String?
    
    var text: String?
    var handle: String?
    var retweetedByHandleString: String?
    var attributeText: NSMutableAttributedString?
    
    var profileUrl: String?
    
    var createdAt: Date?
    var createdAtString: String?
    
    var favorited = false
    var retweeted = false
    var favoriteCount: Int?
    var retweetCount: Int?
    
    var media_included = Bool()
    var mediaImageUrl: URL!
    
    var user_mentions_included = false
     
    init(dictionary: NSDictionary) {
        var entitiesDictionary: NSDictionary?
        var diction = dictionary
        
        if let retweetedStatus = diction["retweeted_status"] as? NSDictionary {
            retweetedByHandleString = (diction.value(forKey: "user") as! NSDictionary).value(forKey: "name") as! String?
            entitiesDictionary = retweetedStatus.value(forKey: "entities") as! NSDictionary?
            diction = retweetedStatus
        }
        
        id = diction.value(forKey: "id") as? Int
        text = diction.value(forKey: "text") as? String
        id_str = diction.value(forKey: "id_str") as? String
        retweetCount = diction.value(forKey: "retweet_count") as? Int
        favoriteCount = diction.value(forKey: "favorite_count") as? Int
        createdAtString = diction.value(forKey: "created_at") as? String
        favorited = diction.value(forKey: "favourited") as? Bool ?? false
        createdAt = Helper.sharedInstance.formatDate(from: createdAtString)
        
        user = User.init(dictionary: diction["user"] as! NSDictionary)
        profileUrl = user?.profileImageUrl
        handle = user?.screenname
    
        // Needed to parse out media, url and hashtag entities
        entitiesDictionary = diction["entities"] as? NSDictionary
        
        // Photo media
        if let media = entitiesDictionary?.value(forKey: "media") as? [NSDictionary?] {
            self.media_included = true
            
            let media_url = media[0]!.value(forKey: "media_url_https") as? String
            let removeFromString = media[0]!.value(forKey: "url") as? String

            self.mediaImageUrl = URL.init(string: media_url!)!

            if let removeRange = self.text!.range(of: removeFromString!) {
                self.text!.replaceSubrange(removeRange, with: "")
                self.attributeText = NSMutableAttributedString(string: self.text!)
                self.text! = self.attributeText!.string
            }
        } else {
            self.media_included = false
            self.attributeText = NSMutableAttributedString(string: self.text!)
        }
        
        // Replace urls with display urls and color them in!
        if let urls = entitiesDictionary?.value(forKey: "urls") as? [NSDictionary?] {
            for mention in urls {
                let url = mention!.value(forKey: "url") as! String?
                let display_url = mention!.value(forKey: "display_url") as! String?
                
                if !(url?.isEmpty)! && !(display_url?.isEmpty)! {
                    self.text! = self.text!.replacingOccurrences(of: url!, with: display_url!)
                    let range = (self.text! as NSString!).range(of: display_url! as String!)
                    self.attributeText = NSMutableAttributedString(string: self.text!)
                    self.attributeText!.addAttribute(NSForegroundColorAttributeName, value: Helper.sharedInstance.twitterBlue(), range: range)
                    
                    self.text! = self.attributeText!.string
                }
            }
        }
                
        // Add user_mentions to colorables
        var colorables = [String?]()
        if let user_mentions = entitiesDictionary?.value(forKey: "user_mentions") as? [NSDictionary?] {
            for mention in user_mentions {
                colorables.append("@\(mention!.value(forKey: "screen_name")!)")
            }
        }
        
        // Add hashtags to colorables
        if let hash_tags = entitiesDictionary?.value(forKey: "hashtags") as? [NSDictionary?] {
            for mention in hash_tags {
                colorables.append("#\(mention!.value(forKey: "text")!)")
            }
        }
        
        // Add color to string for all colorable substrings
        for textToColor in colorables {
            let range = (self.text! as NSString).range(of: textToColor as String!)
            self.attributeText!.addAttribute(NSForegroundColorAttributeName, value: Helper.sharedInstance.twitterBlue(), range: range)
            self.text = self.attributeText!.string
        }
    }
    
    func favoriteCountString(short: Bool) -> String! {
        if short == true {
            return Helper.sharedInstance.formatNumber(truncated: true, number: self.favoriteCount)
        } else {
            return Helper.sharedInstance.formatNumber(truncated: false, number: self.favoriteCount)
        }
    }
    
    func retweetCountString(short: Bool) -> String! {
        if short == true {
            return Helper.sharedInstance.formatNumber(truncated: true, number: self.retweetCount)
        } else {
            return Helper.sharedInstance.formatNumber(truncated: false, number: self.retweetCount)
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
    func favorite(completion: @escaping (_ tweet: Tweet?, _ error: Error?) -> ()) {
        if favorited == false {
            favorited = true
            TwitterClient.sharedInstance.favoriteTweet(tweet: self) { (tweetDictionary, error) in
                if error != nil {
                    self.favorited = false
                    completion(nil, error)
                } else {
                    completion(self, nil)
                }
            }
        }
    }
    
    func unfavorite(completion: @escaping (_ tweet: Tweet?, _ error: Error?) -> ()) {
        if favorited == true {
            favorited = false
            TwitterClient.sharedInstance.unfavoriteTweet(tweet: self) { (tweetDictionary, error) in
                if error != nil {
                    self.favorited = true
                    completion(nil, error)
                } else {
                    completion(self, nil)
                }
            }
        }
    }
    
    func retweet(completion: @escaping (_ tweet: Tweet?, _ error: Error?) -> ()) {
        if retweeted == false {
            retweeted = true
            TwitterClient.sharedInstance.retweetTweet(tweet: self) { (tweetDictionary, error) in
                if error != nil {
                    self.retweeted = false
                    completion(nil, error)
                } else {
                    completion(self, nil)
                }
            }
        }
    }
    
    func unretweet(completion: @escaping (_ tweet: Tweet?, _ error: Error?) -> ()) {
        if retweeted == true {
            retweeted = false
            TwitterClient.sharedInstance.unretweetTweet(tweet: self) { (tweetDictionary, error) in
                if error != nil {
                    self.retweeted = true
                    completion(nil, error)
                } else {
                    completion(self, nil)
                }
            }
        }
    }
    
    func retweetHandle() -> String! {
        let person = retweetedByHandleString ?? "No"
        return "\(person) Retweeted"
    }
    
    func getCreation() -> String? {
        return Helper.sharedInstance.formatDate(truncated: true, date: createdAt)
    }
    
    func getActivitySince() -> String? {
        return Helper.sharedInstance.getActivitySince(createdAt: createdAt)
    }
    
    func colorInEntity(entities: [NSDictionary?], value_of_interest: String!) {
        for entity in entities {
            let handle = "@\(entity!.value(forKey: value_of_interest)!)"
            let range = (self.text! as NSString).range(of: handle as String!)
            self.attributeText!.addAttribute(NSForegroundColorAttributeName, value: Helper.sharedInstance.twitterBlue(), range: range)
            self.text = self.attributeText!.string
        }
    }

}



