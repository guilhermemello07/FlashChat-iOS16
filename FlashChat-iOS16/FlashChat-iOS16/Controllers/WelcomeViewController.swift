//
//  ViewController.swift
//  FlashChat-iOS16
//
//  Created by Guilherme Mello on 08/12/23.
//

import UIKit
import Firebase
import FirebaseAuth
import Security
import CoreData
import GoogleSignIn

class WelcomeViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    var userCredential: AuthCredential?
    
    @IBOutlet weak var appLogoImage: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: K.Segues.segueFromWelcomeToContacts, sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appNameLabel.text = ""
        var counter = 0.0
        for letter in K.appName {
            Timer.scheduledTimer(withTimeInterval: 0.1 * counter + 0.1, repeats: false) { timer in
                self.appNameLabel.text?.append(letter)
            }
            counter += 1
        }
    }
    
    //MARK: - Prepare for Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.segueFromWelcomeToContacts {
            if let destinationVC = segue.destination as? ContactsTableViewController {
                destinationVC.userEmail = userDefaults.string(forKey: K.UserCredentials.userEmail)
            }
        }
    }
    
    //MARK: - Google Sign In Methods
    
    @IBAction func googleSignInButtonPressed(_ sender: GIDSignInButton) {
        guard let clientId = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientId)
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            if let e = error {
                print("Error signing in with Google with: \(e)")
            } else {
                if let user = result?.user {
                    if let idToken = user.idToken?.tokenString {
                        let accessToken = user.accessToken.tokenString
                        self.userCredential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                        Auth.auth().signIn(with: self.userCredential!) { authResult, error in
                            if let e = error {
                                print("Error signing in with Google on Firebase Auth with: \(e)")
                            } else {
                                if let userEmail = authResult?.user.email {
                                    self.userDefaults.set(userEmail, forKey: K.UserCredentials.userEmail)
                                    self.performSegue(withIdentifier: K.Segues.segueFromWelcomeToContacts, sender: self)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

