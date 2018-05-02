//
//  DetailTableViewCell.swift
//  SavvyContact
//
//  Created by Tuan Anh on 23/04/2018.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTittle: UILabel!
    @IBOutlet weak var cellContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
