//
//  HIstoryTableViewCell.swift
//  VisionLearning
//
//  Created by Chan Paul on 19/12/2017.
//  Copyright © 2017年 Chan Paul. All rights reserved.
//

import UIKit

class HIstoryTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var englishName: UILabel!
    @IBOutlet weak var imageOfTheThing:
    UIImageView!
    @IBOutlet weak var translatedName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
