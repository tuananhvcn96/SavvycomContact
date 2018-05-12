//
//  NewContact.swift
//  SavvyContact
//
//  Created by Tuan Anh on 5/7/18.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import Foundation
import UIKit

enum TextFIeldType: Int {
    case firstN = 0
    case lastN = 1
    case phone = 2
    case email = 3
    case street = 4
    case city = 5
    case state = 6
    case country = 7
    case zip = 8
}

class NewContact: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    var newPhoto: UIImageView = UIImageView()
    var contact: Dictionary<String,Any> = [:]
    var addressCellIndexPath: IndexPath?
    let addressCell: CGFloat = 215.0
    let ortherCell: CGFloat = 58.0
    var allContacts = Contact.getGroupedData()
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSaveContact: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnSave(_ sender: Any) {
    
        let contact = Contact(Dictionary: self.contact)
        if var grouped = Contact.getGrouped() {
            let group = contact!.getGroup() 
            
            if grouped.contains(group) {
                allContacts?[group]!.append(contact!)
                allContacts?[group]?.sort {$0.getFullName() < $1.getFullName()}
            } else {
                grouped.append(group)
                
                grouped.sort() {
                    if $0 != "Unknown" && $1 != "Unknown" {
                        return $0 < $1
                    } else {
                        return false
                    }
                }
                allContacts?[group] = [contact!]
            }
            Contact.toFile(data: allContacts!, grouped: grouped, lastId: (contact?.getId())!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func textDidChange(_ sender: UITextField) {
        
        guard let type = TextFIeldType(rawValue: sender.tag) else { return }
        
        
        switch type {
        case .firstN:
//            self.firstN = sender.text ?? ""
            self.contact["firstName"] = sender.text ?? ""
        case .lastN:
            self.contact["lastName"] = sender.text ?? ""
        case .email:
            self.contact["email"] = sender.text ?? ""
        case .phone:
            self.contact["phoneNumber"] = sender.text ?? ""
        case .street:
            self.updateAddress(forKey: "streetAddress", value: sender.text ?? "")
        case .city:
            self.updateAddress(forKey: "city", value: sender.text ?? "")
        case .state:
            self.updateAddress(forKey: "state", value: sender.text ?? "")
        case .country:
            self.updateAddress(forKey: "country", value: sender.text ?? "")
        case .zip:
            self.updateAddress(forKey: "zip", value: sender.text ?? "")
        }
    }
    
    private func updateAddress(forKey: String, value: String) {
        if var add = self.contact["address"] as? Dictionary<String,String> {
            add[forKey] = value
            self.contact["address"] = add
        } else {
            let dict: Dictionary<String,String> = [forKey: value]
            self.contact["address"] = dict
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        newPhoto.image = selectedImage
        //btnSaveContact.isEnabled = validateContact()
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
}

//extension CellDelegate {
//    func updateAvater() {
//        let imagePickerController = UIImagePickerController()
//        
//        imagePickerController.sourceType = .photoLibrary
//        
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true, completion: nil)
//    }
//}

extension NewContact: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? NewFullNameTableViewCell {
                
                if indexPath.section == 0 {
                    cell.fristNameCell.text =  (contact["firstName"] as? String) == "0" ? "" : contact["firstName"] as? String
                } else {
                    cell.lastNameCell.text = contact["lastName"] as? String
                }
                cell.lastNameCell.tag = TextFIeldType.lastN.rawValue
                cell.fristNameCell.tag = TextFIeldType.firstN.rawValue
                
                cell.lastNameCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.fristNameCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                
                return cell
            }
        } else if indexPath.section == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? NewPhoneTableViewCell {
                cell.phoneCell.text = contact["phoneNumber"] as? String
                
                cell.phoneCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.phoneCell.tag = TextFIeldType.phone.rawValue
                return cell
            }
        } else if indexPath.section == 2{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? NewEmailTableViewCell {
                cell.emailCell.text = contact["email"] as? String
                
                cell.emailCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.emailCell.tag = TextFIeldType.email.rawValue
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as? NewAddressTableViewCell {
                cell.streetAddressCell.text = (contact["address"] as? Dictionary<String,String>)?["streetAddress"]
                cell.cityCell.text = (contact["address"] as? Dictionary<String,String>)?["city"]
                cell.stateCell.text = (contact["address"] as? Dictionary<String,String>)?["state"]
                cell.countryCell.text = (contact["address"] as? Dictionary<String,String>)?["country"]
                cell.zipCell.text = (contact["address"] as? Dictionary<String,String>)?["zip"]
                
                cell.streetAddressCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.streetAddressCell.tag = TextFIeldType.street.rawValue
                
                cell.cityCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.cityCell.tag = TextFIeldType.city.rawValue
                
                cell.stateCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.stateCell.tag = TextFIeldType.state.rawValue
                
                cell.countryCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.countryCell.tag = TextFIeldType.country.rawValue
                
                cell.zipCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.zipCell.tag = TextFIeldType.zip.rawValue
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 85
        } else if indexPath.section == 1 {
            return 45
        } else if indexPath.section == 2 {
            return 45
        } else if indexPath.section == 3 {
            return 205
        }
        return UITableViewAutomaticDimension
    }
    
}
