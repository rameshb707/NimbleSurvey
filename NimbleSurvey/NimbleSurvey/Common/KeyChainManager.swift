//
//  KeyChainManager.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 05/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

// This is wrapper for the app to store and fetch the confidential and serured information in the KeyChain
class KeyChainManager: NSObject {
    
    static let sharedInstance = KeyChainManager()
    private override init() {}
    
    func saveToken(token: String?, key: String) -> Bool {
        if let accessToken = token {
            return KeychainWrapper.standard.set(accessToken, forKey: key)
        }
        return false
    }
    
    func fetchToken(tokenKey: String) -> String? {
        let retrievedToken = KeychainWrapper.standard.string(forKey: tokenKey)
        return retrievedToken
    }
    
    func deleteExpiredToken() -> Bool {
        return KeychainWrapper.standard.removeAllKeys()
    }
}
