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
                print("User can be logged in")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("User not found")
                self.alertController.message = "Please try again."
                self.present(self.alertController, animated: true) {}
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "loginSegue" {
            print("Started login segue")
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let mvc = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            let destination = segue.destination as! HamburgerViewController
            
            mvc.hamburgerViewController = destination
            destination.menuViewController = mvc
        }
    }
    
}

