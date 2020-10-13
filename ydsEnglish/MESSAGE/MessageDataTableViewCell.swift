//
//  MessageDataTableViewCell.swift
//  ydsEnglish
//
//  Created by çağrı on 1.05.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit

class MessageDataTableViewCell: UITableViewCell {
    @IBOutlet weak var badgeLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var pimageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
