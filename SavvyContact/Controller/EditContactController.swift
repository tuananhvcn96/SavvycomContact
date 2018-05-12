//
//  NewContactController.swift
//  SavvyContact
//
//  Created by Tuan Anh on 25/04/2018.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class EditContactController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var tableViewInfo: UITableView!
    @IBOutlet weak var tableViewName: UITableView!
    
    @IBOutlet weak var btnSaveContact: UIButton!

    @IBOutlet weak var photoImageView: UIImageView!
    
    var newPhoto: UIImageView = UIImageView()
    var contact: Dictionary<String,Any> = [:]
    var addressCellIndexPath: IndexPath?
    let addressCell: CGFloat = 215.0
    let ortherCell: CGFloat = 58.0

    
    override func viewDidLoad() {
        self.tableViewInfo.delegate = self
        self.tableViewInfo.dataSource = self
        self.tableViewName.dataSource = self
        self.tableViewName.delegate = self
        super.viewDidLoad()
    
        
        if !contact.isEmpty {
            let path = contact["profileImage"] as! String
            if path != "" {
                photoImageView.image = UIImage(contentsOfFile: path)
                Helper.roundImage(photoImageView)
            }
        }
        newPhoto.image = photoImageView.image

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if newPhoto.image != nil {
            photoImageView.image = newPhoto.image
            Helper.roundImage(photoImageView)
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    func addEmailCell(_ cell: UITableViewCell){
        let lbl = UILabel()
        let tfEmailAdd = UITextField()
        let color1 = hexStringToUIColor(hex: "#78f5ff")
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        tfEmailAdd.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = "Email"
        lbl.textColor = color1
        
        tfEmailAdd.placeholder = "Email"
        tfEmailAdd.text = contact["email"] as? String
        tfEmailAdd.borderStyle = .roundedRect
        
        cell.contentView.addSubview(lbl)
        cell.contentView.addSubview(tfEmailAdd)
        
        NSLayoutConstraint.activate([
            lbl.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20),
            lbl.topAnchor.constraint(equalTo: cell.topAnchor, constant: 20),
            lbl.trailingAnchor.constraint(equalTo: tfEmailAdd.leadingAnchor, constant: -13),
            
            tfEmailAdd.topAnchor.constraint(equalTo: cell.topAnchor, constant: 16),
            tfEmailAdd.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 96),
            tfEmailAdd.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -17),
            ])
        
        tfEmailAdd.delegate = self
        tfEmailAdd.tag = 0
        tfEmailAdd.returnKeyType = UIReturnKeyType.next
    }
    
    func addPhoneCell(_ cell: UITableViewCell){
        
        let color1 = hexStringToUIColor(hex: "#78f5ff")

        let lbl = UILabel()
        let tfPhoneAdd = UITextField()
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        tfPhoneAdd.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = "Phone"
        lbl.textColor = color1
        
        tfPhoneAdd.placeholder = "Phone"
        tfPhoneAdd.text = contact["phoneNumber"] as? String
        tfPhoneAdd.borderStyle = .roundedRect
        
        cell.contentView.addSubview(lbl)
        cell.contentView.addSubview(tfPhoneAdd)
        
        NSLayoutConstraint.activate([
            lbl.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20),
            lbl.topAnchor.constraint(equalTo: cell.topAnchor, constant: 20),
            lbl.trailingAnchor.constraint(equalTo: tfPhoneAdd.leadingAnchor, constant: -13),
            
            tfPhoneAdd.topAnchor.constraint(equalTo: cell.topAnchor, constant: 16),
            tfPhoneAdd.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 96),
            tfPhoneAdd.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -17),
        ])
        
        tfPhoneAdd.delegate = self
        tfPhoneAdd.tag = 1
        tfPhoneAdd.returnKeyType = UIReturnKeyType.next
    }
    
    
    func addAddressCell(_ cell: UITableViewCell) {
        let lbl = UILabel()
        let tfStreetAdd = UITextField()
        let tfCity = UITextField()
        let tfState = UITextField()
        let tfCountry = UITextField()
        let tfZip = UITextField()
        
        let color1 = hexStringToUIColor(hex: "#78f5ff")
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        tfStreetAdd.translatesAutoresizingMaskIntoConstraints = false
        tfCity.translatesAutoresizingMaskIntoConstraints = false
        tfState.translatesAutoresizingMaskIntoConstraints = false
        tfCountry.translatesAutoresizingMaskIntoConstraints = false
        tfZip.translatesAutoresizingMaskIntoConstraints = false

        
        lbl.text = "Address"
        lbl.textColor = color1
        
        tfStreetAdd.placeholder = "Street Address"
        tfStreetAdd.text = (contact["address"] as? Dictionary<String,String>)?["streetAddress"]
        tfStreetAdd.borderStyle = .roundedRect
        
        tfCity.placeholder = "City"
        tfCity.text = (contact["address"] as? Dictionary<String,String>)?["city"]
        tfCity.borderStyle = .roundedRect
        
        tfState.placeholder = "State"
        tfState.text = (contact["address"] as? Dictionary<String,String>)?["state"]
        tfState.borderStyle = .roundedRect
        
        tfCountry.placeholder = "Country"
        tfCountry.text = (contact["address"] as? Dictionary<String,String>)?["country"]
        tfCountry.borderStyle = .roundedRect
        
        tfZip.placeholder = "Zip"
        tfZip.text = (contact["address"] as? Dictionary<String,String>)?["zip"]
        tfZip.borderStyle = .roundedRect
        
        
        cell.contentView.addSubview(lbl)
        cell.contentView.addSubview(tfStreetAdd)
        cell.contentView.addSubview(tfCity)
        cell.contentView.addSubview(tfState)
        cell.contentView.addSubview(tfCountry)
        cell.contentView.addSubview(tfZip)
        
        NSLayoutConstraint.activate([
            
            lbl.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20),
            lbl.topAnchor.constraint(equalTo: cell.topAnchor, constant: 88),
            lbl.trailingAnchor.constraint(equalTo: tfState.leadingAnchor, constant: -13),
            
            tfStreetAdd.topAnchor.constraint(equalTo: cell.topAnchor, constant: 20),
            tfStreetAdd.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 96),
            tfStreetAdd.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -17),
            
            tfCity.topAnchor.constraint(equalTo: tfStreetAdd.bottomAnchor, constant: 8),
            tfCity.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 96),
            tfCity.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -17),
            
            tfState.topAnchor.constraint(equalTo: tfCity.bottomAnchor, constant: 8),
            tfState.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 96),
            tfState.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -17),
            
            tfCountry.topAnchor.constraint(equalTo: tfState.bottomAnchor, constant: 8),
            tfCountry.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 96),
            tfCountry.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -17),
            
            tfZip.topAnchor.constraint(equalTo: tfCountry.bottomAnchor, constant: 8),
            tfZip.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 96),
            tfZip.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -17)
            
            ])
  
        tfStreetAdd.delegate = self
        tfStreetAdd.tag = 0
        tfStreetAdd.returnKeyType = UIReturnKeyType.next
        
        tfCity.delegate = self
        tfCity.tag = 1
        tfCity.returnKeyType = UIReturnKeyType.next
        
        tfState.delegate = self
        tfState.tag = 2
        tfState.returnKeyType = UIReturnKeyType.next
        
        tfCountry.delegate = self
        tfCountry.tag = 3
        tfCountry.returnKeyType = UIReturnKeyType.next
        
        tfZip.delegate = self
        tfZip.tag = 4
        tfZip.returnKeyType = UIReturnKeyType.go
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if btnSaveContact.isEqual(sender) {
            
            var cells = tableViewName.visibleCells as! [NewContactTableViewCell]
            for i in 0..<cells.count {
                var key: String = ""
                switch i {
                case 0:
                    key = "firstName"
                case 1:
                    key = "lastName"
                default:
                    break
                }
                contact[key] = cells[i].inputName.text
            }
            cells = tableViewInfo.visibleCells as! [NewContactTableViewCell]
            for i in 0..<cells.count {
                var key: String = ""
                switch i {
                case 0:
                    key = "phoneNumber"
                case 1:
                    key = "email"
                case 2:
                    key = "address"
                default:
                    break
                }
                if key != "address" {
                    contact[key] = cells[i].inputInfo.text == cells[i].inputInfo.placeholder ? "" : cells[i].inputInfo.text
                } else {
                    contact[key] = getAddInfo(cells[i])
                }
            }
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    func getAddInfo(_ cell : UITableViewCell) -> Dictionary<String,String>{
      var dict: Dictionary<String,String> = [:]
        let allSubViews = cell.contentView.subviews
        for i in 2..<allSubViews.count {
            let textField = allSubViews[i] as! UITextField
            var key = textField.placeholder!.lowercased()
            if key == "street address" {
                key = "streetAddress"
            }
            dict[key] = textField.text  
        }
        return dict
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        // Set photoImageView to display the selected image.
        newPhoto.image = selectedImage
        //btnSaveContact.isEnabled = validateContact()
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
}

extension EditContactController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == self.tableViewName) ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        if tableView == tableViewName {
            let cell = tableViewName.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewContactTableViewCell
            cell.inputName.delegate = self
            if indexPath.row == 0 {
                cell.inputName.placeholder = "First Name"
                cell.inputName.text = (contact["firstName"] as? String) == "0" ? "" : contact["firstName"] as? String
                
            } else {
                cell.inputName.placeholder = "Last Name"
                cell.inputName.text = contact["lastName"] as? String
            }
            return cell
        } else {
            
            let cell = tableViewInfo.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewContactTableViewCell
            cell.inputInfo.delegate = self
            
            switch indexPath.row {
            case 0:
                cell.inputInfo.placeholder = "Phone Number"
                if let info = contact["phoneNumber"] as? String {
                    cell.inputInfo.text = info
                }
//                guard let addTextField = cell.inputInfo else { break }
//                addTextField.removeFromSuperview()
//                addPhoneCell(cell)
            case 1:
//                guard let addTextField = cell.inputInfo else {break}
//                addTextField.removeFromSuperview()
//                addEmailCell(cell)
                cell.inputInfo.placeholder = "Email"
                if let info = contact["email"] as? String {
                    cell.inputInfo.text = info
                }
            case 2:
                addressCellIndexPath = indexPath
                guard let addTextField = cell.inputInfo else {break}
                addTextField.removeFromSuperview()
                addAddressCell(cell)
            default: break
                
            }
            return cell
        }
        
    }

}

extension EditContactController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if addressCellIndexPath == indexPath {
            return addressCell
        }
        return ortherCell
    }
}
