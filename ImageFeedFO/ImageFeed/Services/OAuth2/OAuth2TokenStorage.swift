import Foundation
import SwiftKeychainWrapper


final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    private let tokenKey = "Auth token"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}

extension OAuth2TokenStorage {
    func clearToken() {
        KeychainWrapper.standard.removeObject(forKey: tokenKey)
        KeychainWrapper.standard.removeObject(forKey: "refresh_token")
    }
}
