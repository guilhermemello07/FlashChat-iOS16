//
//  KeychainManager.swift
//  FlashChat-iOS16
//
//  Created by Guilherme Mello on 03/02/24.
//

import Foundation
import Security

class KeychainManager {
    
    //MARK: - Save User Credentials static function
    static func saveUserCredentials(account: String, password: String) throws {
        let userPassword = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: userPassword]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
        
    //MARK: - Get User Credentials function
    static func getUserCredentials(account: String) throws -> Credentials {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String: Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let userPassword = String(data: passwordData, encoding: String.Encoding.utf8),
              let userAccount = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.UnexpectedPasswordData
        }
        return Credentials(username: userAccount, password: userPassword)
    }
    
    //MARK: - Update User Credentials function
    static func updateUserCredentials(account: String, password: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account]
        
        let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                         kSecValueData as String: password]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
    }
    
    //MARK: - Delete User Credentials function
    static func deleteUserCredentials(account: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
}
