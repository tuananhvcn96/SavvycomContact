//
//  NewPhoneTableViewCell.swift
//  SavvyContact
//
//  Created by Tuan Anh on 5/7/18.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class NewPhoneTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneCell: UITextField!
    @IBOutlet weak var phoneCellTest: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        phoneCell.placeholder = "Phone Number"
    }


}
