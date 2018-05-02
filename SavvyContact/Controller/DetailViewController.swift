//
//  DetailViewController.swift
//  SavvyContact
//
//  Created by Tuan Anh on 23/04/2018.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    static let indentifier = "contactDetail"
    
//    @IBOutlet weak var fristName: UILabel!
//    @IBOutlet weak var lastName: UILabel!
//    @IBOutlet weak var phoneName: UILabel!
//    @IBOutlet weak var email: UILabel!
//    @IBOutlet weak var streetAddress: UILabel!
//    @IBOutlet weak var city: UILabel!
//    @IBOutlet weak var state: UILabel!
//    @IBOutlet weak var country: UILabel!
//    @IBOutlet weak var zip: UILabel!

    @IBOutlet weak var imageViewhuman: UIImageView!
    @IBOutlet weak var fristName: UILabel!
    @IBOutlet weak var lastName: UILabel!

    var contactDetail: Contact?
    var oldContact: Contact?
    var data: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if contactDetail?.getGroup() != "Unknown" {
            fristName.text = contactDetail?.getFirstName()
            lastName.text = contactDetail?.getLastName()
        } else {
            fristName.text = "Unknown"
            lastName.text = "Unknown"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shouldUpdateUI()
    }
    
    func shouldUpdateUI() {
        if contactDetail?.getProfileImage() == "" {
            imageViewhuman.image = UIImage(named: "thor")
        } else {
            imageViewhuman.image = UIImage(contentsOfFile: (contactDetail?.getProfileImage())!)
            Helper.roundImage(imageViewhuman)
            
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailTableViewCell
        var title: String?
        var content: String?
//        guard let infoDetail = self.data else { return cell }
        switch indexPath.row {
        case 0:
            title = "Phone Number"
            content =  contactDetail?.getPhoneNumber()
        case 1:
            title = "Email"
            content =  contactDetail?.getEmail()
        case 2:
            title = "Address"
            content = contactDetail?.getAddress()
        default:
            break
        }
        cell.cellTittle.text = title
        cell.cellContent.text = content
        return cell
    }
    
}

