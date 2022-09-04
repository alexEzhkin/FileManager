//
//  KeychainService.swift
//  FileManager
//
//  Created by Alex on 20.07.22.
//

import KeychainSwift
import UIKit

class KeychainService {
    static let shared = KeychainService()
    
    private let keychain = KeychainSwift()
    
    private init() { }
    
    func getPassword() -> String? {
        keychain.get(KeychainKey.password.rawValue)
    }
    
    func setPassword(value: String) {
        keychain.set(value, forKey: KeychainKey.password.rawValue)
    }
}

enum KeychainKey: String {
    case password
}
