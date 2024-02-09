//
//  ContactsTableViewController.swift
//  FlashChat-iOS16
//
//  Created by Guilherme Mello on 31/01/24.
//

import UIKit
import Firebase
import Security
import CoreData

class ContactsTableViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var contactsObj = [Contacts]()
    
    var messageReceiver: String?
    var userEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.contactCellNibName, bundle: nil), forCellReuseIdentifier: K.contactCellIdentifier)
        loadContacts()
        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows in section is: \(contactsObj.count)")
        return contactsObj.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.contactCellIdentifier, for: indexPath) as! ContactTableViewCell
        cell.contactLabel.text = contactsObj[indexPath.row].email
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contactToDelete = contactsObj[indexPath.row]
            contactsObj.remove(at: indexPath.row)
            context.delete(contactToDelete)
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Define the messageReceiver for the "prepareForSegue" method
        messageReceiver = contactsObj[indexPath.row].email
        performSegue(withIdentifier: K.Segues.segueFromContactsToChat, sender: self)
    }
    
    //MARK: - IBAction Functions
    @IBAction func addContactButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add contact", message: "Enter contact email", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "type email"
        }
        alert.addAction(UIAlertAction(title: "add", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields![0] {
                if let contactEmail = textField.text {
                    if contactEmail != "" {
                        var isEmailFound = false
                        for contact in self.contactsObj {
                            if let email = contact.value(forKey: K.CoreDataModel.Contacts.entityAttrEmail) as? String, email == contactEmail {
                                let alert = UIAlertController(title: "Contact already added", message: "Review the contact email or add another contact", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                isEmailFound = true
                                break
                            }
                        } //OUT of for loop
                        if !isEmailFound {
                            let newContact = Contacts(context: self.context)
                            newContact.email = contactEmail
                            newContact.userEmail = self.userEmail
                            self.saveContacts()
                            DispatchQueue.main.async {
                                self.loadContacts()
                            }
                        }
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            if let account = userDefaults.string(forKey: K.UserCredentials.userEmail) {
                try KeychainManager.deleteUserCredentials(account: account)
                userDefaults.removeObject(forKey: K.UserCredentials.userEmail)
                navigationController?.popToRootViewController(animated: true)
            }
        } catch {
            let alert = UIAlertController(title: "Error signing out", message: "Please, try again or review your network connection", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - SaveContacts
    func saveContacts() {
        do {
            try context.save()
        } catch {
            print("Error saing data to CoreData with: \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Load Contacts
    func loadContacts() {
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        let predicate = NSPredicate(format: "userEmail CONTAINS[cd] %@", userEmail!)
        request.predicate = predicate
        do {
            contactsObj = try context.fetch(request)
        } catch {
            print("Error fetching data from CoreData with: \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Prepare For Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.segueFromContactsToChat {
            if let destinationVC = segue.destination as? ChatsViewController {
                destinationVC.messageReceiver = messageReceiver
                destinationVC.messageSender = contactsObj.last?.userEmail
            }
        }
    }
}
