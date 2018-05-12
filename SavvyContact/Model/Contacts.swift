//
//  Contacts.swift
//  SavvyContact
//
//  Created by Tuan Anh on 17/04/2018.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//
import UIKit


struct Address {
    var streetAddress: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    var country: String = ""

    init(Dictionary addrDict: Dictionary<String,String>) {
        self.city = addrDict["city"]!
        self.country = addrDict["country"]!
        self.state = addrDict["state"]!
        self.streetAddress = addrDict["streetAddress"]!
        self.zip = addrDict["zip"]!
    }
    func toDict() -> Dictionary<String,String> {
        var dict: Dictionary<String,String> = [:]
        
        dict["streetAddress"] = streetAddress
        dict["city"] = city
        dict["state"] = state
        dict["zip"] = zip
        dict["country"] = country
        
        return dict
    }
    
    func getStreetAddress() -> String?{
        return self.streetAddress
    }
    
    func getCity() -> String?{
        return self.city
    }
    
    func getState() -> String? {
        return self.state
    }
    
    func getZip() -> String? {
        return ", Zip: \(zip)"
    }
    
    func getCountry() -> String? {
        return self.country
    }
    func getAddress() -> String? {
        return " " + streetAddress + "\n" + city + "\n" + state + "\n" + country + "\n" + "Zip: \(zip)"
    }

}

class Contact: ConnectDB  {
    private static let dataFileName = "ContactList"
    static var contentUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    var contactList: [Contact] = [Contact]()
    private var group: String = "Unknown"
    private var firstName: String = "0"
    private var lastName: String?
    private var profileImage: String?
    private var email: String?
    private var phoneNumber: String = String()
    private var id: Int?
    private var address: Address?
    init?(){
        super.init(dataFileName: Contact.dataFileName)
        self.id = getLastId() + 1
    }
    
    /* khoi tao doi tuong Contact lay tu dbase*/
    init?(Dictionary dict: Dictionary<String,Any>) {
        super.init(dataFileName: Contact.dataFileName)
        let fName = dict["firstName"] as? String
        if fName != "" {
            self.firstName = fName!
        }
        self.phoneNumber = dict["phoneNumber"] as! String
        self.lastName = dict["lastName"] as? String
        self.profileImage = dict["profileImage"] as? String
        self.email = dict["email"] as? String
        if let addrDict = dict["address"] as? Dictionary<String,String> {
            self.address = Address(Dictionary: addrDict)
        }
        self.id = getLastId() + 1
        if let id = dict["id"] as? Int {
            self.id = id
        }
        if self.firstName != "0" {
            self.group = String(self.firstName.characters.first!)
            
        } else if self.lastName != ""{
            self.group = String((self.lastName?.characters.first!)!)
        } else {
            self.group = "Unknown"
        }
    }
    
    
    func getFirstName() -> String {
        return self.firstName
    }
    
    func getLastName() -> String {
        return self.lastName!
    }
    
    func getFullName() -> String {
        if self.lastName! == "" {
            return self.firstName
        } else if self.firstName != "0" {
            return (self.firstName + " " + lastName!).trimmingCharacters(in: [" "])
        } else {
            return lastName!
        }
    }
    
    func getId() -> Int {
        return self.id!
    }
    func getPhoneNumber() -> String {
        return self.phoneNumber
    }
    func getGroup() -> String {
        return self.group
    }
    func getLastId() -> Int {
        let obContactDB = ConnectDB(dataFileName: Contact.dataFileName)!
        guard let lastId = obContactDB.getDataToNSMutableArr()?[0] as? Int
            else {return 0}
        return lastId
    }
    
    
    func getEmail() -> String? {
        return self.email
    }
    
    func getAddress() -> String? {
        return self.address?.getAddress()?.trimmingCharacters(in: [" "])
    }
    
    func getStreetAddress() -> String?{
        return self.address?.getZip()
    }
    func getCity() -> String?{
        return self.address?.getCity()
    }
    
    func getState() -> String? {
        return self.address?.getState()
    }
    
    func getZip() -> String? {
        return self.address?.getZip()
    }
    
    func getCountry() -> String? {
        return self.address?.getCountry()
    }
    
    func getProfileImage() -> String? {
        return self.profileImage
    }
    
    func setProfileImage(_ image: UIImage, _ imageName: String) {
        if image.isEqual(UIImage(named: "thor")) {
            self.profileImage = ""
        } else {
            let data = UIImagePNGRepresentation(image)
            print(data)
            var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            url.appendPathComponent(imageName)
            do {
                try data?.write(to: url)
                self.profileImage = url.path
            } catch {
                print("can't save image")
            }
            
        }
    }

    class func getAllContactsToArr() -> [Contact]? {
        let obContactDB = ConnectDB(dataFileName: Contact.dataFileName)
        guard let allData = obContactDB?.getDataToNSMutableArr() else {return nil}
        allData.removeObject(at: 0)
        allData.removeObject(at: 0)
        var allContacts = [Contact]()
        for item in allData {
            let dict = item as! Dictionary<String,Any>
            allContacts.append(Contact(Dictionary: dict)!)
        }
        return allContacts
    }
    
    class func getGrouped() -> [String]? {
        let obContactDB = ConnectDB(dataFileName: Contact.dataFileName)
        guard let allData = obContactDB?.getDataToNSMutableArr() else {return nil}
        return (allData[1] as! [String])
    }
    
    class func getGroupedData() -> [String:Array<Contact>]? {
        guard let allContacts = Contact.getAllContactsToArr() else {return nil}
        var groupedContacts = [String:Array<Contact>]()
        guard let group = Contact.getGrouped() else {return nil}
        for gr in group {
            groupedContacts[gr] = allContacts.filter({$0.getGroup() == gr})
        }
        return groupedContacts
    }
    
    static func toFile(data: [String: Array<Contact>], grouped: [String], lastId: Int) {
        if let connectDB = ConnectDB(dataFileName: Contact.dataFileName) {
            
            var dataMapped = (data.flatMap {$0.value})
            var data4Write = dataMapped as Array<Any>
            
            for i in 0..<data4Write.count {
                data4Write[i] = dataMapped[i].toDict()
            }
            data4Write.insert(grouped, at: 0)
            data4Write.insert(lastId, at: 0)
            let path = connectDB.getDataSavedPath()
            (data4Write as NSArray).write(toFile: path!, atomically: true)
        }
    }
    
    func toDict() -> Dictionary<String,Any> {
        var dict: Dictionary<String,Any> = [:]
        dict["firstName"] = self.firstName
        dict["lastName"] = self.lastName
        dict["phoneNumber"] = self.phoneNumber
        dict["address"] = self.address?.toDict()
        dict["group"] = self.group
        dict["email"] = self.email
        dict["id"] = self.id
        dict["profileImage"] = self.profileImage
        return dict
    }

}
