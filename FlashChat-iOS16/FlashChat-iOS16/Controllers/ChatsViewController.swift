//
//  ChatsViewController.swift
//  FlashChat-iOS16
//
//  Created by Guilherme Mello on 30/01/24.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatsViewController: UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    var messageReceiver: String?
    var messageSender: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var messageStackViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)

        //Register for Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        // Unregister for keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = messageReceiver
        loadMessages()
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: - Keyboard Handling
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            tableView.contentInset = contentInset
            tableView.scrollIndicatorInsets = contentInset

            messageStackViewBottomConstraint.constant = keyboardSize.height 
            
            scrollToBottom()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }

    func scrollToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        messageStackViewBottomConstraint.constant = 20
    }
    
    //MARK: - Load Messages Function
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .whereFilter(Filter.andFilter([
                Filter.whereField(K.FStore.messageReceiver, in: [messageSender!, messageReceiver!]),
                Filter.whereField(K.FStore.messageSender, in: [messageSender!, messageReceiver!])]))
            .order(by: K.FStore.messageDate)
            .addSnapshotListener { querySnapshot, error in
            if let e = error {
                print(e)
            } else {
                self.messages = []
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.messageSender] as? String, let messageBody = data[K.FStore.messageBody] as? String, let messageRec = data[K.FStore.messageReceiver] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody, receiver: messageRec)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }


    //MARK: - IBAction Functions
    @IBAction func sendMessageButtonPressed(_ sender: UIButton) {
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email, let messageRec = messageReceiver {
            db.collection("messages").addDocument(data: [K.FStore.messageSender: messageSender,
                                                                              K.FStore.messageBody: messageBody,
                                                                              K.FStore.messageReceiver: messageRec,
                                                                              K.FStore.messageDate: Date().timeIntervalSince1970]) { error in
                if let e = error {
                    let alert = UIAlertController(title: "Error sending message", message: "Error: \(e.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.loadMessages()
                    self.messageTextField.text = ""
                }
            }
        }
    }
}

//MARK: - UITableViewDataSource Extension
extension ChatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].body
        
        //message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImage.isHidden = true
            cell.rightImage.isHidden = false
            cell.messageView.backgroundColor = UIColor(named: K.BrandColors.gray)
            cell.messageLabel.textColor = UIColor(named: K.BrandColors.cold)
        } else {
            cell.leftImage.isHidden = false
            cell.rightImage.isHidden = true
            cell.messageView.backgroundColor = UIColor(named: K.BrandColors.cold)
            cell.messageLabel.textColor = UIColor(named: K.BrandColors.gray)
        }
        return cell
    }
}



