# FlashChat-iOS16
This is FlashChat version 1.0

## App highlights


https://github.com/guilhermemello07/FlashChat-iOS16/assets/72673965/30f4d2be-0597-4e91-9edb-bd4ca1d1ac64




## Purpose of the app
This simple instant messaging iOS application allows users to send and receive instant messages from each other, considering they are already an added contact on both accounts.

## Reasons to build this app
The main reason I built this app is to showcase some of the most important iOS app implementation techniques, which consist of using the most important APIs for iOS development.

The original idea of this application was borrowed from [Angela Yu's Udemy course on iOS development.](https://www.udemy.com/course/ios-13-app-development-bootcamp/)

## App Features
- User Authentication:
- Google Sign In 
- Contact Management:
- Instant Messaging:
- Data Persistence:
- Security:
- Keyboard Management:

## Technologies Used
- Swift
- UiKit
- UserDefaults
- Keychain
- IQKeyboardManagerSwift
- CoreData
- GoogleSignIn
- Firebase
- Firebase Firestore
- Firebase Auth
- MVC Design Pattern
- Swift Packet Manager
- Cocoa Touch Classes
- Storyboard

## Installation 
As this app is only available through this GitHub repo, you'll need to run it locally, and to do this, just follow the steps:

- Register on [Firebase](https://firebase.google.com/) with your Google account
- When in the Firebase console, click on 'Add project'
    - Choose a name for your project and wait a moment for it to run
    - Then you will land on your project page, from there, you need to click on 'iOS+' to begin adding Firebase to your project
    - At this point you just need to provide the Apple Bundle ID for your app and additional information in order to get your config file
    - You will also need to go to your project and enable both email/password auth and Google auth.
    - After downloading the config file, just paste it near the info.plist on your Xcode project.
- Clone this GitHub repository
- Open the '.xcodeproj' file on Xcode
- Build and Run the project on a simulator or physical device.

## How to use the app
- Run the app on the simulator or physical device
- On the WelcomeViewController you can choose to Register as a new user or login
    - To register as a new user, just click Register and follow the instructions
    - To log in, if you already have registered an account, you just need to provide your email and password.
    - In both cases, you will be asked by the app if you want it to remember your credentials, and if you choose so, the app will not prompt you for credentials again.
- On the ContactsViewController you can add and remove contacts, and every contact you have added will appear on the tableView.
    - To add contacts you need to click on the '+' button and provide the email of the contact you want to add
      - The contact you add will need to have an account and have to add you as well
    - To delete a contact that you have already added, you just need to click the 'edit' button and proceed as usual
    - To go to the chat related to that specific contact, you just need to click on the contact email on the tableView
- On the ChatViewController you can send and receive instant text messages
- Enjoy the project!


