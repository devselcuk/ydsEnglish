//
//  ExamMenuTableViewCell.swift
//  ydsEnglish
//
//  Created by çağrı on 4.05.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit

class ExamMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
