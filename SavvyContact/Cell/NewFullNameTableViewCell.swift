//
//  NewFullNameTableViewCell.swift
//  SavvyContact
//
//  Created by Tuan Anh on 5/7/18.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class NewFullNameTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fristNameCell: UITextField!
    @IBOutlet weak var lastNameCell: UITextField!
    
    @IBOutlet weak var fristnameTest: UITextField!
    @IBOutlet weak var lastNametest: UITextField!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        fristNameCell.placeholder = "Frist Name"
//        lastNameCell.placeholder = "Last Name"
        
        fristnameTest.placeholder = "Frist Name"
        lastNametest.placeholder = "Last Name"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
        func textFieldDidEndEditing(_ textField: UITextField) {
        fristnameTest.text = textField.text
    }
    
}
