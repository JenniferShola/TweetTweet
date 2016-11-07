//
//  Helper.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/30/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    class var sharedInstance: Helper {
        struct Static {
            static let instance = Helper()
        }
        return Static.instance
    }
    
    var formatter = DateFormatter()
    var formatterShort = DateFormatter()
    var formatterSubShort = DateFormatter()
    let numberFormatter = NumberFormatter()
    
    let calendar = Calendar.current
    let unitFlags = Set([Calendar.Component.year, Calendar.Component.weekOfYear, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]) as Set<Calendar.Component>

    override init() {
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        formatterShort.dateFormat = "M/d/yy h:mma"
        formatterSubShort.dateFormat = "MMM d"
    }
    
    func formatDate(truncated: Bool?, date: Date?) -> String? {
        if truncated == nil {
            return formatterSubShort.string(from: date!)
        } else if truncated == true {
            return formatterShort.string(from: date!)
        } else {
            return formatter.string(from: date!)
        }
    }
    
    func formatDate(from: String?) -> Date? {
        return formatter.date(from: from!)
    }
    
    func twitterBlue() -> UIColor {
        return UIColor.init(red: CGFloat.init(42.0/255.0), green: CGFloat.init(163.0/255.0), blue: CGFloat.init(239.0/255.0), alpha: 1)
    }
    
    func twitterGray() -> UIColor {
        return UIColor.init(red: CGFloat.init(170.0/255.0), green: CGFloat.init(184.0/255.0), blue: CGFloat.init(194.0/255.0), alpha: 1)
    }
    
    func twitterPink() -> UIColor {
        return UIColor.init(red: CGFloat.init(232.0/255.0), green: CGFloat.init(28.0/255.0), blue: CGFloat.init(79.0/255.0), alpha: 1)
    }
    
    func twitterPink(alpha: CGFloat?) -> UIColor {
        return UIColor.init(red: CGFloat.init(232.0/255.0), green: CGFloat.init(28.0/255.0), blue: CGFloat.init(79.0/255.0), alpha: alpha!)
    }
    
    func formatNumber(truncated: Bool, number: Int?) -> String! {
        if truncated == true {
            if number! > 1000000 {
                return "\((number!/1000000))M" as String!
            } else if number! > 1000 {
                return "\((number!/1000))k" as String!
            } else {
                return "\(number!)" as String!
            }
        } else {
            return numberFormatter.string(from: NSNumber(value: number!))
        }
    }
    
    func getActivitySince(createdAt: Date?) -> String? {
        let components:DateComponents = calendar.dateComponents(unitFlags, from: createdAt!, to: Date())
        
        if (components.year! >= 1) {
            return "\(components.year!)y"
        } else if (components.month! >= 2) {
            return "\(components.month!)m"
        } else if (components.weekOfYear! >= 1) {
            return "\(components.weekOfYear!)w"
        } else if (components.day! >= 1) {
            return "\(components.day!)d"
        } else if (components.hour! >= 1) {
            return "\(components.hour!)h"
        } else if (components.minute! >= 1) {
            return "\(components.minute!)m"
        } else if (components.second! >= 1) {
            return "\(components.second!)s"
        }
        
        return "0s"
    }
    
    func setButtonImage(button: UIButton!, imageName: String!) {
        button.setBackgroundImage(UIImage(named: imageName), for: UIControlState.normal)
    }
    
    func setFavoriteActionButton(favorited: Bool?, button: UIButton?) {
        if favorited! == true {
            Helper.sharedInstance.setButtonImage(button: button, imageName: "favoriteActionOn")
        } else {
            Helper.sharedInstance.setButtonImage(button: button, imageName: "favoriteAction")
        }
    }
    
    func setRetweetActionButton(retweeted: Bool?, button: UIButton?) {
        if retweeted! == true {
            Helper.sharedInstance.setButtonImage(button: button, imageName: "retweetActionOn")
        } else {
            Helper.sharedInstance.setButtonImage(button: button, imageName: "retweetAction")
        }
    }
    
    
    
    
    
}
