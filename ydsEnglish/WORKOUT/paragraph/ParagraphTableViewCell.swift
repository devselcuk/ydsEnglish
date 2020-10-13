//
//  ParagraphTableViewCell.swift
//  DaysTableView
//
//  Created by çağrı on 22.04.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit

class ParagraphTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lockPic: UIImageView!
    @IBOutlet weak var paraPic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
