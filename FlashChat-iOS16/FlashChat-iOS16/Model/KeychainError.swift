//
//  KeychainError.swift
//  FlashChat-iOS16
//
//  Created by Guilherme Mello on 03/02/24.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case UnexpectedPasswordData
    case unhandledError(status: OSStatus)
}
