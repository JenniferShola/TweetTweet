//
//  User.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/27/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "currentUser"
let userDidLoginNotification = Notification.Name("userDidLoginNotification")
let userDidLogoutNotification = Notification.Name("userDidLogoutNotification")

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = "@\(dictionary["screen_name"] as! String)"
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NotificationCenter.default.post(name: userDidLogoutNotification, object: nil)
    }
    
    class func login(completion: @escaping (_ user: User?, _ error: Error?) -> ()) {
        TwitterClient.sharedInstance.loginWithCompletion() { (user: User?, error: Error?) in
            if user != nil {
                completion(user, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = UserDefaults.standard.object(forKey: currentUserKey) as? Data
                if data != nil {
                    do {
                        if let dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                            _currentUser = User(dictionary: dictionary)
                        }
                    } catch {
                        // didn't work
                        UserDefaults.standard.set(nil, forKey: currentUserKey)
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    if let data = try JSONSerialization.data(withJSONObject: user!.dictionary, options: JSONSerialization.WritingOptions.prettyPrinted) as Data? {
                        UserDefaults.standard.set(data, forKey: currentUserKey)
                    }
                } catch {
                    // didn't work
                    UserDefaults.standard.set(nil, forKey: currentUserKey)
                }
            } else {
                UserDefaults.standard.set(nil, forKey: currentUserKey)
            }
            UserDefaults.standard.synchronize()
        }
    }
}
