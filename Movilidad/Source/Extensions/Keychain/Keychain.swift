//
//  Keychain.swift
//  Movilidad
//
//  Created by Diego Quimbo on 7/2/22.
//

enum KeychainKey: String, CaseIterable {
    case user = "user"
    case password = "password"
}

struct Keychain {
    
    /* SINGLETON */
    static let shared = Keychain()
    
    private let keychain = KeychainSwift()
    
    private init() { }
    
    /// save the username (email) and password
    func saveUserCredentials(email: String, password: String) {
        keychain.set(email, forKey: KeychainKey.user.rawValue)
        keychain.set(password, forKey: KeychainKey.password.rawValue)
    }
    
    /// - Returns: the username and password (tuple)
    func getUserCredentials() -> (user: String, password: String)? {
        guard let user = keychain.get(KeychainKey.user.rawValue),
              let password = keychain.get(KeychainKey.password.rawValue) else {
            return nil
        }
        
        return (user, password)
    }
    
    /// clear the Keychain
    func clear() {
        // Clear all keys saved
        for key in KeychainKey.allCases {
            keychain.delete(key.rawValue)
        }
    }
}
