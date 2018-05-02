//
//  HomeController.swift
//  SavvyContact
//
//  Created by Tuan Anh on 17/04/2018.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var allContacts = Contact.getGroupedData()
    let searchController = UISearchController(searchResultsController: nil)
    var allContacts4Search: [Contact]? = []
    var matchedContact = [Contact]()
    var contactString = Contact.getGrouped()
    var contact: Contact?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func searchContact(searchText: String) {
        matchedContact = (allContacts4Search?.filter {   (contact) in
            let match = Helper.matches(for: "^\\d+$", in: searchText)
            if !match.isEmpty {
                return contact.getPhoneNumber().lowercased().contains(searchText.lowercased())
            } else {return contact.getFullName().lowercased().contains(searchText.lowercased())}
            })!
        tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        allContacts4Search = Contact.getAllContactsToArr()
        tableView.reloadData()
    }
    @IBAction func unwindToContactView(sender: UIStoryboardSegue) {
        let sourceView = sender.source as? NewContactController
        let contact = Contact(Dictionary: (sourceView?.contact)!)!
        contact.setProfileImage((sourceView?.photoImageView.image)!, String(contact.getId())+".png")
        if var grouped = Contact.getGrouped() {
            let group = contact.getGroup()      //group cua Contact moi
            
            // kiem tra xem group cua contact moi da ton tai hay chua
            if grouped.contains(group) {
                allContacts?[group]!.append(contact)
                allContacts?[group]?.sort {$0.getFullName() < $1.getFullName()}
            } else {
                grouped.append(group)
                
                // sort danh sach, Unkown luon o dau danh sach
                grouped.sort() {
                    if $0 != "Unknown" && $1 != "Unknown" {
                        return $0 < $1
                    } else {
                        return false
                    }
                }
                allContacts?[group] = [contact]
            }
            Contact.toFile(data: allContacts!,grouped: grouped,lastId: contact.getId())
            tableView.reloadData()
        }
    }
    
    func scrollToNewCell(indexPath: IndexPath) {
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
}

extension HomeController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        } else {
            guard let sections = allContacts?.count else { return 1 }
            return sections
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return matchedContact.count
        } else {
            let group = Contact.getGrouped()
            return (allContacts![group![section]]?.count)!
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //         Configure the cell...
        if searchController.isActive && searchController.searchBar.text != "" {
            var matched = matchedContact[indexPath.row].getFullName()
            if matched == "0" {
                matched = "Unknown"
            }
            
            matched += " - "
            matched += matchedContact[indexPath.row].getPhoneNumber()
            cell.textLabel?.text = matched
        } else {
            let group = Contact.getGrouped()
            guard let fullName = allContacts?[(group?[indexPath.section])!]?[indexPath.row].getFullName() else { return cell }
            if fullName == "0" {
                guard let phonNum = allContacts?[(group?[indexPath.section])!]?[indexPath.row].getPhoneNumber() else { return cell }
                cell.textLabel?.text = phonNum
            } else {
                cell.textLabel?.text = fullName
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return "Matched"
        } else {
            guard let group = Contact.getGrouped() else { return "" }
            let header = group[section]
            return header
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailViewController = segue.destination as! DetailViewController
            if let selectedCellIndexPath = tableView.indexPath(for: (sender as! UITableViewCell)) {
                if searchController.isActive && searchController.searchBar.text != "" {
                    let selectedContact = matchedContact[selectedCellIndexPath.row]
                    detailViewController.contactDetail = selectedContact
                } else {
                    if let groups = Contact.getGrouped() {
                        let group = groups[selectedCellIndexPath.section]
                        let selectedContact = allContacts?[group]?[selectedCellIndexPath.row]
                        detailViewController.contactDetail = selectedContact
                    }
                    
                }
            }
        }
    }
}

extension HomeController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
      searchContact(searchText: searchController.searchBar.text!)
    }
}




