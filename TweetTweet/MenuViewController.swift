//
//  MenuViewController.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 11/6/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var timelineNavigationController: UIViewController!
    private var userProfileNavigationController: UIViewController!
    private var mentionsViewController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        userProfileNavigationController = storyboard.instantiateViewController(withIdentifier: "UserProfile")
        
        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "navMentionsViewController")
        
        viewControllers = [userProfileNavigationController, timelineNavigationController, mentionsViewController]
        
        hamburgerViewController.contentViewController = timelineNavigationController

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        let titles = ["Profile", "Timeline", "Mentions"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("This row is being shown: \(indexPath.row)")
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
