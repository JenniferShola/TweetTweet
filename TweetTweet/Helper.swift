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
    let numberFormatter = NumberFormatter()
    
    let calendar = Calendar.current
    let unitFlags = Set([Calendar.Component.year, Calendar.Component.weekOfYear, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]) as Set<Calendar.Component>

    override init() {
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        formatterShort.dateFormat = "M/d/yy h:mma"
    }
    
    func formatDate(truncated: Bool, date: Date?) -> String? {
        if truncated == true {
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
}
