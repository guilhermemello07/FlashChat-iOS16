//
//  RegisterViewController.swift
//  FlashChat-iOS16
//
//  Created by Guilherme Mello on 08/12/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    var userEmail: String?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: K.BrandColors.yellow)
    }
    
    //MARK: - IBAction Functions
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text {
            userEmail = email
            if password == confirmPassword {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.confirmPasswordTextField.text = ""
                    } else {
                        let saveAlert = UIAlertController(title: "Remember password", message: "Do you want the app to remember you?", preferredStyle: UIAlertController.Style.alert)
                        saveAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                            self.userDefaults.set(email, forKey: K.UserCredentials.userEmail)
                            //Save UserCredentials to Keychain
                            let credentials = Credentials(username: email, password: password)
                            let userAccount = credentials.username
                            let userPassword = credentials.password
                            do {
                                try KeychainManager.saveUserCredentials(account: userAccount, password: userPassword)
                            } catch {
                                print("Error")
                            }
                            self.performSegue(withIdentifier: K.Segues.segueFromRegisterToContacts, sender: self)
                        }))
                        saveAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                            self.performSegue(withIdentifier: K.Segues.segueFromRegisterToContacts, sender: self)
                        }))
                        self.present(saveAlert, animated: true, completion: nil)
                    }
                }
            } else { //different passwords
                let alert = UIAlertController(title: "Incorrect Password", message: "Passwords don't match.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.passwordTextField.text = ""
                self.confirmPasswordTextField.text = ""
            }
        }
    }
    
    //MARK: - Prepare For Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.segueFromRegisterToContacts {
            if let destinationVC = segue.destination as? ContactsTableViewController {
                destinationVC.userEmail = userEmail
            }
        }
    }
}
