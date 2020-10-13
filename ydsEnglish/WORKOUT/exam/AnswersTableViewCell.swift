//
//  AnswersTableViewCell.swift
//  ydsEnglish
//
//  Created by çağrı on 5.05.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit

class AnswersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var qNumLabel: UILabel!
    
    @IBOutlet weak var correctAnswerLabel: UILabel!
    
    @IBOutlet weak var givenAnswerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
