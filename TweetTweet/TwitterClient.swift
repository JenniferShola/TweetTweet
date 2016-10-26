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

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            
        }
        return Static.instance!
    }
}
