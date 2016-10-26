//
//  ViewController.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/25/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(_ sender: AnyObject) {
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token",
                                                       method: "GET",
                                                       callbackURL: URL(string: "jennifershola.com"),
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
        })
    }

}

