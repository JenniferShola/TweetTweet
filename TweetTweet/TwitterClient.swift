//
//  TwitterClient.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/26/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerSecret = "xC96pt1ppDiwsAQOAUanZUwWRBBfGBD7PWPy0vCBRsGCnvNFHI"
let twitterConsumerKey = "blsGjyfpZmObrghbfKa9vVdEe"

let twitterBaseUrl = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {

    var loginCompletion: ((User?, Error?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance!
    }
    
    func showUser(screen_name: String?, params: NSDictionary?, completion: @escaping (_ user: User?, _ error: Error?) -> ()){
        get("1.1/users/show.json?screen_name=\(screen_name!)", parameters: params, success: { (operation, response) in
            let usr = User.init(dictionary: response as! NSDictionary)
            completion(usr, nil)
        }) { (operation, error) in
            print("ERROR getting current home TL: \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    func userProfile(params: NSDictionary?, completion: @escaping (_ user: User?, _ error: Error?) -> ()){
        get("1.1/users/show.json", parameters: params, success: { (operation, response) in
            let usr = User.init(dictionary: response as! NSDictionary)
            completion(usr, nil)
            }, failure: { (operation, error) in
                print("ERROR getting current home TL: \(error.localizedDescription)")
                completion(nil, error)
        })
    }
    
    func homeTimeline(params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> ()){
        get("1.1/statuses/home_timeline.json", parameters: params, success: { (operation, response) in
            let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
            completion(tweets, nil)
            }, failure: { (operation, error) in
                print("ERROR getting current home TL: \(error.localizedDescription)")
                completion(nil, error)
        })
    }
    
    func mentionsTimeline(params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> ()){
        get("1.1/statuses/mentions_timeline.json", parameters: params, success: { (operation, response) in
            print("Here is the response: \(response)")
            let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
            print("Here are the tweets: \(tweets)")
            completion(tweets, nil)
        }, failure: { (operation, error) in
            print("ERROR getting current mentions TL: \(error.localizedDescription)")
            completion(nil, error)
        })
    }
    
    func userTimeline(params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> ()){
        get("1.1/statuses/user_timeline.json", parameters: params, success: { (operation, response) in
            let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
            completion(tweets, nil)
        }, failure: { (operation, error) in
            print("ERROR getting current user TL: \(error.localizedDescription)")
            completion(nil, error)
        })
    }
    
    func favoriteAction(endpoint: String?, tweet: Tweet?, completion: @escaping (_ dictionary: NSDictionary?, _ error: Error?) -> ()){
        let keys = ["id"]
        let params = NSDictionary.init(objects: [tweet!.id!], forKeys: keys as [NSCopying])
        
        post("1.1/favorites/\(endpoint!).json", parameters: params, success: { (operation, response) in
            completion((response as! NSDictionary), nil)
        }, failure: { (operation, error) in
            print("ERROR favoriting tweet: \(error.localizedDescription)")
            completion(nil, error)
        })
    }
    
    func favoriteTweet(tweet: Tweet?, completion: @escaping (_ dictionary: NSDictionary?, _ error: Error?) -> ()){
        favoriteAction(endpoint: "create", tweet: tweet, completion: completion)
    }
    
    func unfavoriteTweet(tweet: Tweet?, completion: @escaping (_ dictionary: NSDictionary?, _ error: Error?) -> ()){
        favoriteAction(endpoint: "destroy", tweet: tweet, completion: completion)
    }
    
    func retweetAction(endpoint: String?, tweet: Tweet?, completion: @escaping (_ dictionary: NSDictionary?, _ error: Error?) -> ()){
        let keys = ["id", "id_str", "trim_user"]
        let params = NSDictionary.init(objects: [tweet!.id, tweet!.id_str, false], forKeys: keys as [NSCopying])
        
        post("1.1/statuses/\(endpoint!)/\(params.value(forKey: "id_str") as! String).json", parameters: params, success: { (operation, response) in
            completion((response as! NSDictionary), nil)
        }, failure: { (operation, error) in
            print("ERROR retweeting tweet: \(error.localizedDescription)")
            completion(nil, error)
        })
    }
    
    func composeTweet(status: String?, in_reply_to: Int?, completion: @escaping (_ dictionary: NSDictionary?, _ error: Error?) -> ()){
        let keys = ["status", "in_reply_to_status_id"]
        let params = NSDictionary.init(objects: [status!, 123], forKeys: keys as [NSCopying])
        
        post("1.1/statuses/update.json", parameters: params, success: { (operation, response) in
            completion((response as! NSDictionary), nil)
        }, failure: { (operation, error) in
            print("ERROR composing tweet: \(error.localizedDescription)")
            completion(nil, error)
        })
    }
    
    func retweetTweet(tweet: Tweet?, completion: @escaping (_ tweet: NSDictionary?, _ error: Error?) -> ()){
        retweetAction(endpoint: "retweet", tweet: tweet, completion: completion)
    }
    
    func unretweetTweet(tweet: Tweet?, completion: @escaping (_ tweet: NSDictionary?, _ error: Error?) -> ()){
        retweetAction(endpoint: "unretweet", tweet: tweet, completion: completion)
    }
    
    func loginWithCompletion(completion: @escaping (_ user: User?, _ error: Error?) -> ()) {
        loginCompletion = completion

        requestSerializer.removeAccessToken()
        fetchRequestToken(withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "shola://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) -> Void in
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
                print("url: \(authURL)")
                UIApplication.shared.open(authURL!)
        },
        failure: { (error: Error?) -> Void in
            self.loginCompletion!(nil, error)
        })
    }
    
    func openUrl(url: URL) {
        fetchAccessToken(withPath: "oauth/access_token",
                         method: "POST",
                         requestToken: BDBOAuth1Credential (queryString: url.query),
                         success: { (accessToken: BDBOAuth1Credential?) -> Void in
                            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                            
                            TwitterClient.sharedInstance.get("1.1/account/verify_credentials.json", parameters: nil,
                                                             success: { (operation, response) in
                                    print("USER HERE: \(response)")
                                                                
                                    let user = User(dictionary: response as! NSDictionary)
                                    User.currentUser = user
                                    self.loginCompletion!(user, nil)
                                    
                                }, failure: { (operation, error) in
                                    print("ERROR getting current user")
                                    self.loginCompletion!(nil, error)
                            })
                            
            },
                         failure: { (error: Error?) -> Void in
                            print("failed to get access token")
                            self.loginCompletion!(nil, error)
        })
    }
    
    
}
