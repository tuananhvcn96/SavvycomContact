//
//  NewContactTableViewCell.swift
//  SavvyContact
//
//  Created by Tuan Anh on 4/27/18.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class NewContactTableViewCell: UITableViewCell {

    @IBOutlet weak var inputInfo: UITextField!
    @IBOutlet weak var validationInfo: UILabel!
    @IBOutlet weak var validationName: UILabel!
    @IBOutlet weak var inputName: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func validateName() -> Bool {
        let match = Helper.matches(for: ".*[^\\n\\s]", in: inputName.text!)
        if inputName.text != "" && match.isEmpty {
            validationName.text = "Invalid Name!"
        } else {
            validationName.text = ""
            return true
        }
        return !match.isEmpty
    }
    
    func validateEmail() -> Bool {
        inputInfo.text = inputInfo.text?.trimmingCharacters(in: [" "])
        let match = Helper.matches(for: "(^[\\w.+-]+@[\\w-]+\\.[\\w-]+)(\\.[\\w]+)?$", in: inputInfo.text!)
        if inputInfo.text != "" && inputInfo.text != inputInfo.placeholder && match.isEmpty {
            validationInfo.text = "Invalid Email!"
        } else {
            validationInfo.text = ""
            return true
        }
        return !match.isEmpty
        
    }
    
    func validatePhoneNum() -> Bool {
        inputInfo.text = inputInfo.text?.trimmingCharacters(in: [" "])
        let match = Helper.matches(for: "^(\\d{10,11})$", in: inputInfo.text!)
        if inputInfo.text != "" && inputInfo.text != inputInfo.placeholder && match.isEmpty {
            validationInfo.text = "Invalid Phone number!"
        } else {
            validationInfo.text = ""
            return true
        }
        return !match.isEmpty
        
    }


}
