//
//  NewEmailTableViewCell.swift
//  SavvyContact
//
//  Created by Tuan Anh on 5/7/18.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class NewEmailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emailCell: UITextField!
    @IBOutlet weak var emailCellTest: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        emailCell.placeholder = "Email"
    }
    
}
