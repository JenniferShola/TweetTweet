//
//  ViewController.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 10/25/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onLogin(_ sender: AnyObject) {
        User.login { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                self.alertController.message = "Please try again."
                self.present(self.alertController, animated: true) {}
            }
        }
    }
    
}

