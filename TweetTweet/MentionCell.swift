//
//  MentionCell.swift
//  TweetTweet
//
//  Created by Shola Oyedele on 11/6/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class MentionCell: UITableViewCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var replyToLabel: UILabel!
    
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var mentionDateLabel: UILabel!
    @IBOutlet weak var mentionTextLabel: UILabel!
    
    @IBOutlet weak var replyAction: UIImageView!
    @IBOutlet weak var retweetAction: UIButton!
    @IBOutlet weak var favoriteAction: UIButton!
    
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
