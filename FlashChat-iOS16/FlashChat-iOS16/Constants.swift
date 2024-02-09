//
//  Constants.swift
//  FlashChat-iOS16
//
//  Created by Guilherme Mello on 08/12/23.
//

import Foundation


struct K {
    
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let contactCellIdentifier = "ContactReusableCell"
    static let contactCellNibName = "ContactTableViewCell"
    
    struct Segues {
        static let segueFromWelcomeToContacts = "fromWelcomeToContacts"
        static let segueFromRegisterToContacts = "fromRegisterToContacts"
        static let segueFromLoginToContacts = "fromLoginToContacts"
        static let segueFromContactsToChat = "fromContactsToChat"
    }
    
    struct BrandColors {
        static let gray = "NewGray"
        static let cold = "NewCold"
        static let lightGray = "NewLightGray"
        static let yellow = "NewYellow"
        static let navy = "NewNavy"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let messageSender = "sender"
        static let messageReceiver = "receiver"
        static let messageBody = "body"
        static let messageDate = "date"
    }
    
    struct CoreDataModel {
        static let dataModelIdentifier = "DataModel"
        
        struct Contacts {
            static let entityIdentifier = "Contacts"
            static let entityAttrEmail = "email"
        }
    }
    
    struct UserCredentials {
        static let userEmail = "userEmail"
        static let userPassword = "userPassword"
    }
    
}
