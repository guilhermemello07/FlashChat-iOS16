//
//  LoginViewController.swift
//  FlashChat-iOS16
//
//  Created by Guilherme Mello on 08/12/23.
//

import UIKit
import Security
import Firebase

class LoginViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    var userEmail: String?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: K.BrandColors.yellow)
        loginButton.tintColor = UIColor(named: K.BrandColors.yellow)
    }
    
    //MARK: - IBAction Functions
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            userEmail = email
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error { //Refer to the 'FIRAuthErrors' to handle each error with a switch statement !
                    let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.passwordTextField.text = ""
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
                        self.performSegue(withIdentifier: K.Segues.segueFromLoginToContacts, sender: self)
                    }))
                    saveAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                        self.performSegue(withIdentifier: K.Segues.segueFromLoginToContacts, sender: self)
                    }))
                    self.present(saveAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        //Implement a way for the user to reset their password.
        if let email = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let e = error {
                    print("Error sending email to reset password with: \(e)")
                } else {
                    let alert = UIAlertController(title: "Email sent", message: "Go to your email inbox and reset your password", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: - Prepare For Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.segueFromLoginToContacts {
            let destinationVC = segue.destination as! ContactsTableViewController
            destinationVC.userEmail = self.userEmail
        }
    }
}
