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
    
    var profileUrl: String?
    
    var createdAt: NSDate?
    var createdAtString: String?
    
    var favorited = false
    var retweeted = false
    var favoriteCount: Int?
    var retweetCount: Int?
    
    var formatter = DateFormatter()
    
    init(dictionary: NSDictionary) {
        if let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary {
            
            
            text = retweetedStatus.value(forKey: "text") as! String?
            id = retweetedStatus.value(forKey: "id") as! Int?
            id_str = retweetedStatus.value(forKey: "id_str") as! String?
            favoriteCount = retweetedStatus.value(forKey: "favorite_count") as! Int?
            retweetCount = retweetedStatus.value(forKey: "retweet_count") as! Int?
            
            
            retweetedByHandleString = (dictionary.value(forKey: "user") as! NSDictionary).value(forKey: "name") as! String?
            user = User.init(dictionary: retweetedStatus.value(forKey: "user") as! NSDictionary)
            handle = user?.screenname
            profileUrl = user?.profileImageUrl
            createdAtString = retweetedStatus.value(forKey: "created_at") as! String?
        } else {
            user = User.init(dictionary: dictionary["user"] as! NSDictionary)
            handle = user?.screenname
            profileUrl = user?.profileImageUrl
            text = dictionary["text"] as? String
            id = dictionary["id"] as? Int
            id_str = dictionary["id_str"] as? String
            favoriteCount = dictionary["favorite_count"] as? Int
            retweetCount = dictionary["retweet_count"] as? Int
            createdAtString = dictionary["created_at"] as? String
        }
        
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.date(from: createdAtString!) as NSDate?
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
                    self.updateTweetValues(dictionary: tweetDictionary!)
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
                    self.updateTweetValues(dictionary: tweetDictionary!)
                    let rc = self.favoriteCount!
                    self.favoriteCount = rc-1
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
                    self.updateTweetValues(dictionary: tweetDictionary!)
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
                    self.updateTweetValues(dictionary: tweetDictionary!)
                    let rc = self.retweetCount!
                    self.retweetCount = rc-1
                    completion(self, nil)
                }
            }
        }
    }
    
    func getLongReadableDate(){
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.date(from: createdAtString!) as NSDate?
    }
    
    func updateTweetValues(dictionary: NSDictionary) {
        if let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary {
            self.retweetedByHandleString = (dictionary.value(forKey: "user") as! NSDictionary).value(forKey: "name") as! String?
            self.text = retweetedStatus.value(forKey: "text") as! String?
            self.id = retweetedStatus.value(forKey: "id") as! Int?
            self.id_str = retweetedStatus.value(forKey: "id_str") as! String?
            self.favoriteCount = retweetedStatus.value(forKey: "favorite_count") as! Int?
            self.retweetCount = retweetedStatus.value(forKey: "retweet_count") as! Int?
            self.user = User.init(dictionary: retweetedStatus.value(forKey: "user") as! NSDictionary)
            self.handle = user?.screenname
            self.profileUrl = user?.profileImageUrl
            self.createdAtString = retweetedStatus.value(forKey: "created_at") as! String?
        } else {
            self.user = User.init(dictionary: dictionary["user"] as! NSDictionary)
            self.handle = user?.screenname
            self.profileUrl = user?.profileImageUrl
            self.text = dictionary["text"] as? String
            self.id = dictionary["id"] as? Int
            self.id_str = dictionary["id_str"] as? String
            self.favoriteCount = dictionary["favorite_count"] as? Int
            self.retweetCount = dictionary["retweet_count"] as? Int
            self.createdAtString = dictionary["created_at"] as? String
        }
        
        createdAt = formatter.date(from: createdAtString!) as NSDate?
    }

}






