//
//  KeychainProvider.swift
//  DragonBall
//
//  Created by Manuel Cazalla Colmenero on 11/10/23.
//

import Foundation
import KeychainSwift

protocol SecureDataProviderProtocol {
    func save(token: String)
    func getToken() -> String?
}

final class SecureDataProvider: SecureDataProviderProtocol {
    
    private enum Key {
        static let token = "KEY_KEYCHAIN_TOKEN"
    }
    
    private let keychain = KeychainSwift()
    
    func save(token: String) {
        keychain.set(token, forKey: Key.token)
        
    }
    
    func getToken() -> String? {
        keychain.get(Key.token)
    }
}
