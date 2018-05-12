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
    @IBOutlet weak var tableInfo: UITableView!

    var contactDetail: Contact?
    var oldContact: Contact?
    var data: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldContact = contactDetail
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editCOntroller = segue.destination.childViewControllers.first as! EditContactController
        editCOntroller.contact = (contactDetail?.toDict())!
    }
    
    @IBAction func unwindToContactView(sender: UIStoryboardSegue) {
        let sourceView = sender.source as? EditContactController
        contactDetail = Contact(Dictionary: (sourceView?.contact)!)!
        let id = contactDetail?.getId()
        contactDetail?.setProfileImage((sourceView?.photoImageView.image)!, String(id!)+".png")
        tableInfo.reloadData()
        shouldUpdateUI()
        
        let contactVC = navigationController?.childViewControllers.first! as! HomeController
        var grouped = Contact.getGrouped()
        let group = contactDetail?.getGroup()
        var oldGroupContact = contactVC.allContacts?[(oldContact?.getGroup())!]
        let index = oldGroupContact?.index(where: {$0.getId() == contactDetail?.getId()})
        oldGroupContact?.remove(at: index!)
        
        if oldContact?.getGroup() == group {
            oldGroupContact?.append(contactDetail!)
            if group != "Unknown" {
                oldGroupContact?.sort {$0.getFullName() < $1.getFullName()}
            }
            contactVC.allContacts?[group!] = oldGroupContact
        } else {
            if (grouped?.contains(group!))! {
                contactVC.allContacts?[group!]?.append(contactDetail!)
                if group != "Unknown" {
                    contactVC.allContacts?[group!]?.sort {$0.getFullName() < $1.getFullName()}
                }
            } else {
                grouped?.append(group!)
                grouped?.sort() {return $0 < $1}
                if (grouped?.contains("Unknown"))! {
                    grouped?.remove(at: (grouped?.index(where: {$0 == "Unknown"})!)!)
                    grouped?.insert("Unknown", at: 0)
                }
                contactVC.allContacts?[group!] = [contactDetail!]
            }
            if (oldGroupContact?.isEmpty)! {
                contactVC.allContacts?[(oldContact?.getGroup())!] = nil
                grouped?.remove(at: (grouped?.index(where: {$0 == (oldContact?.getGroup())!}))!)
            } else {
                contactVC.allContacts?[(oldContact?.getGroup())!] = oldGroupContact
            }
        }
        Contact.toFile(data: contactVC.allContacts!,grouped: grouped!,lastId: (contactDetail?.getLastId())!)
    }
}


extension DetailViewController: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else if indexPath.row == 1 {
            return 80
        } else if indexPath.row == 2 {
            return 150
        } else if indexPath.row == 3 {
            return 80
        } else if indexPath.row == 3 {
            return 30
        } else if indexPath.row == 3 {
            return 30
        }
            return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.deselectRow(at: indexPath, animated: true)

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailTableViewCell
        var title: String?
        var content: String?
//        guard let infoDetail = self.data else { return cell }
        switch indexPath.row {
        case 0:
            title = "Phone"
            content =  contactDetail?.getPhoneNumber()
        case 1:
            title = "Email"
            content =  contactDetail?.getEmail()
        case 2:
            title = "Work"
            content = contactDetail?.getAddress()
        case 3:
            title = "Notes"
            if title == "Notes"{
                cell.cellTittle.textColor = UIColor.black
            }
        case 4:
            title = "Send Message"
        case 5:
            title = "Share Contact"
        default:
            break
        }
        cell.cellTittle.text = title
        cell.cellContent.text = content
        return cell
    }
    
}

