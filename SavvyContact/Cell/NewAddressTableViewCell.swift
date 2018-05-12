//
//  NewAddressTableViewCell.swift
//  SavvyContact
//
//  Created by Tuan Anh on 5/7/18.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class NewAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var streetAddressCell: UITextField!
    @IBOutlet weak var cityCell: UITextField!
    @IBOutlet weak var stateCell: UITextField!
    @IBOutlet weak var countryCell: UITextField!
    @IBOutlet weak var zipCell: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        streetAddressCell.placeholder = "Street Address"
        cityCell.placeholder = "City"
        stateCell.placeholder = "State"
        countryCell.placeholder = "Country"
        zipCell.placeholder = "Zip"
    }

}
