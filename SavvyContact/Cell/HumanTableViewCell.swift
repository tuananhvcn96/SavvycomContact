//
//  HumanTableViewCell.swift
//  SavvyContact
//
//  Created by Tuan Anh on 17/04/2018.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class HumanTableViewCell: UITableViewCell {

    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var fristName: UILabel!
    @IBOutlet weak var imagehuman: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
