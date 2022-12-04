//
//  AccountPref.swift
//  Rawg
//
//  Created by Enrico Irawan on 24/11/22.
//

import Foundation

struct UserPref {
    static let nameKey = "name"
    static let emailKey = "email"
    
    static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? "Not set yet"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }
        
    static var email: String {
        get {
            return UserDefaults.standard.string(forKey: emailKey) ?? "Not set yet"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: emailKey)
        }
    }
    
    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
