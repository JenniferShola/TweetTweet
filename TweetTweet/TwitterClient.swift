//
//  TwitterClient.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/26/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "blsGjyfpZmObrghbfKa9vVdEe"
let twitterConsumerSecret = "xC96pt1ppDiwsAQOAUanZUwWRBBfGBD7PWPy0vCBRsGCnvNFHI"
//let twitterConsumerKey = "Zwi6PYVjgkXwXhodsla7jVaz9"
//let twitterConsumerSecret = "DCtIS3p2kgslg7vqBAWXqzTPvejfhy5KPTm91yhiAapa3acSqv"
let twitterBaseUrl = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {

    var loginCompletion: ((User?, Error?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance!
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
                print("got request token: \(requestToken!.debugDescription)")
                print("token: \(requestToken!.token!)")
                print("secret: \(requestToken!.secret!)")
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
                print("url: \(authURL)")
                UIApplication.shared.open(authURL!)
        },
        failure: { (error: Error?) -> Void in
            print("failed to get request token error: \(error!.localizedDescription)")
            self.loginCompletion!(nil, error)
        })
    }
    
    func openUrl(url: URL) {
        fetchAccessToken(withPath: "oauth/access_token",
                         method: "POST",
                         requestToken: BDBOAuth1Credential (queryString: url.query),
                         success: { (accessToken: BDBOAuth1Credential?) -> Void in
                            print("got access token: \(accessToken!.debugDescription)")
                            print("token: \(accessToken!.token!)")
                            print("secret: \(accessToken!.secret!)")
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
