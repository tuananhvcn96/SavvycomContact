//
//  NewContactController.swift
//  SavvyContact
//
//  Created by Tuan Anh on 25/04/2018.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class NewContactController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
            let path = contact["prolileImage"] as! String
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
    
    func addAddressCell(_ cell: UITableViewCell) {
        let lbl = UILabel()
        let tfStreetAdd = UITextField()
        let tfCity = UITextField()
        let tfState = UITextField()
        let tfCountry = UITextField()
        let tfZip = UITextField()
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        tfStreetAdd.translatesAutoresizingMaskIntoConstraints = false
        tfCity.translatesAutoresizingMaskIntoConstraints = false
        tfState.translatesAutoresizingMaskIntoConstraints = false
        tfCountry.translatesAutoresizingMaskIntoConstraints = false
        tfZip.translatesAutoresizingMaskIntoConstraints = false

        
        lbl.text = "Address"
        
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
        tfCity.delegate = self
        tfState.delegate = self
        tfCountry.delegate = self
        tfZip.delegate = self
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

extension NewContactController: UITableViewDataSource {

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
                cell.inputInfo.text = "Phone Number"
                cell.inputInfo.placeholder = "Phone Number"
                if let info = contact["phoneNumber"] as? String {
                    cell.inputInfo.text = info
                }
            case 1:
                cell.inputInfo.text = "Email"
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

extension NewContactController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if addressCellIndexPath == indexPath {
            return addressCell
        }
        return ortherCell
    }
}
