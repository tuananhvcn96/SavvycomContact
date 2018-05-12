//
//  HeaderCell.swift
//  SavvyContact
//
//  Created by Tuan Anh on 5/9/18.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fristNameCell: UITextField!
    @IBOutlet weak var lastNameCell: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fristNameCell.placeholder = "Frist Name"
        lastNameCell.placeholder = "Last Name"
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateAvatar))
        self.avatarImageView.isUserInteractionEnabled = true
        self.avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    func updateAvatar() {
        
    }
    
    @IBAction func abc() {
        
    }

}
