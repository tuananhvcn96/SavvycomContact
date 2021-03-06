//
//  TestViewController.swift
//  SavvyContact
//
//  Created by Tuan Anh on 5/10/18.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit
import Foundation

enum TextFieldType: Int {
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

class NewContactViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!

    var contact: Dictionary<String,Any> = [:]
    var addressCellIndexPath: IndexPath?
    let addressCell: CGFloat = 215.0
    let ortherCell: CGFloat = 58.0
    var allContacts = Contact.getGroupedData()
    var newPhoto: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = navigationBarItem()
        newPhoto.isUserInteractionEnabled = true
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FullNameCell") as! NewFullNameTableViewCell
        
        if !contact.isEmpty {
            let path = contact["profileImage"] as! String
            if path != "" {
                cell.avatarImageView.image = UIImage(contentsOfFile: path)
                Helper.roundImage(cell.avatarImageView)
            }
        }
        cell.avatarImageView.image = newPhoto.image
        
    }
    
    func navigationBarItem() -> UIBarButtonItem {
        let saveData = UIButton(type: .system)
        saveData.setImage(#imageLiteral(resourceName: "check").withRenderingMode(.alwaysOriginal), for: .normal)
        saveData.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        saveData.addTarget(self, action: #selector(self.onTapMenu), for: .touchUpInside)
        return UIBarButtonItem(customView: saveData)
    }
    
    func onTapMenu() {
        
        let contact = Contact(Dictionary: self.contact)
        contact!.setProfileImage((newPhoto.image)!, String(contact!.getId())+".png")
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
            tableView.reloadData()
        }
        self.dismiss(animated: true, completion: nil)

    }


    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func textDidChange(_ sender: UITextField) {
        
        guard let type = TextFieldType(rawValue: sender.tag) else { return }

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
    
    func scrollToNewCell(indexPath: IndexPath) {
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true;
        }
        return false
    }

    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        newPhoto.image = selectedImage
        tableView.reloadData()
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
}

extension NewContactViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FullNameCell", for: indexPath) as? NewFullNameTableViewCell {
                cell.lastNametest.tag = TextFieldType.lastN.rawValue
                cell.fristnameTest.tag = TextFieldType.firstN.rawValue
                
                cell.lastNametest.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.fristnameTest.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                
                if newPhoto.image != nil {
                    cell.avatarImageView.image = newPhoto.image
                    Helper.roundImage(cell.avatarImageView)
                }
                
                cell.fristnameTest.delegate = self
                cell.fristnameTest.tag = 0
                cell.fristnameTest.returnKeyType = UIReturnKeyType.next
                
                cell.lastNametest.delegate = self
                cell.lastNametest.tag = 1
                cell.lastNametest.returnKeyType = UIReturnKeyType.next
                
                return cell
            }
        } else if indexPath.section == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell", for: indexPath) as? NewPhoneTableViewCell {
                
                cell.phoneCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.phoneCell.tag = TextFieldType.phone.rawValue
                
                cell.phoneCell.delegate = self
                cell.phoneCell.tag = 2
                cell.phoneCell.returnKeyType = UIReturnKeyType.next
                return cell
            }
        } else if indexPath.section == 2{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath) as? NewEmailTableViewCell {
                
                cell.emailCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.emailCell.tag = TextFieldType.email.rawValue
                
                cell.emailCell.delegate = self
                cell.emailCell.tag = 3
                cell.emailCell.returnKeyType = UIReturnKeyType.go
                
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as? NewAddressTableViewCell {
                
                cell.streetAddressCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.streetAddressCell.tag = TextFieldType.street.rawValue
                
                cell.cityCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.cityCell.tag = TextFieldType.city.rawValue
                
                cell.stateCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.stateCell.tag = TextFieldType.state.rawValue
                
                cell.countryCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.countryCell.tag = TextFieldType.country.rawValue
                
                cell.zipCell.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                cell.zipCell.tag = TextFieldType.zip.rawValue
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
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
