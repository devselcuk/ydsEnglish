//
//  MessageTableViewCell.swift
//  ydsEnglish
//
//  Created by çağrı on 1.05.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var cellViewLeadingConst: NSLayoutConstraint!
    
    @IBOutlet weak var cellViewTrailingConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
