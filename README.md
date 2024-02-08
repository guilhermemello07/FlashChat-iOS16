# FlashChat-iOS16
This is FlashChat version 1.0

## App highlights

-> ** Will include videos of the app running with all it's features! **

## Purpose of the app
This simple instant messaging iOS application allows users to send and receive instant messages from each other, considering they are already an added contact on both accounts.

## Reasons to build this app
The main reason I built this app is to showcase some of the most important iOS app implementation techniques, which consist of using the most important APIs for iOS development.

The original idea of this application was borrowed from [Angela Yu's Udemy course on iOS development.](https://www.udemy.com/course/ios-13-app-development-bootcamp/)

## App Features
- User Authentication:
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
- Firebase
- Firebase Firestore
- Firebase Auth
- MVC Design Pattern
- Swift Packet Manager
- Cocoa Touch Classes
- Storyboard

## Installation 
As this app is only available through this GitHub repo, you'll need to run it locally, and to do this, just follow the steps:

1- Register on [Firebase](https://firebase.google.com/) with your Google account
2- When in the Firebase console, click on 'Add project'
  2.1 - Choose a name for your project and wait a moment for it to run
  2.2 - Then you will land on your project page, from there, you need to click on 'iOS+' to begin adding Firebase to your project
  2.3 - At this point you just need to provide the Apple Bundle ID for your app and additional information in order to get your config file
  2.4 - After downloading the config file, just paste it near the info.plist on your Xcode project.
3- Clone this GitHub repository
4- Open the '.xcodeproj' file on Xcode
5- Build and Run the project on a simulator or physical device.

## How to use the app
1- Run the app on the simulator or physical device
2- On the WelcomeViewController you can choose to Register as a new user or login
  2.1 - To register as a new user, just click Register and follow the instructions
  2.2 - To log in, if you already have registered an account, you just need to provide your email and password.
  2.3 - In both cases, you will be asked by the app if you want it to remember your credentials, and if you choose so, the app will not prompt you for credentials again.
3- On the ContactsViewController you can add and remove contacts, and every contact you have added will appear on the tableView.
  3.1 - To add contacts you need to click on the '+' button and provide the email of the contact you want to add
    3.1.1 - The contact you add will need to have an account and have to add you as well
  3.2 - To delete a contact that you have already added, you just need to click the 'edit' button and proceed as usual
  3.3 - To go to the chat related to that specific contact, you just need to click on the contact email on the tableView
4- On the ChatViewController you can send and receive instant text messages
5- Enjoy the project!

## App Report

**Provide an app report, describing every feature and explaining the approach of each implementation!!!! **

