//
//  KeychainHelper.swift
//  Vault
//
//  Created by Steven Shang on 2/28/17.
//  Copyright © 2017 Steven Shang. All rights reserved.
//

// Source Citation: http://stackoverflow.com/questions/37539997/save-and-load-from-keychain-swift
// God bless StackOverflow

import Foundation
import Security

let serviceValue = "KeyForPassword"

let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

open class KeychainHelper: NSObject {
    
    public static let standard = KeychainHelper()
    
    public func savePassword(username: String, password: String) {
        self.save(service: serviceValue as NSString, account: username as NSString, data: password as NSString)
    }
    
    public func loadPassword(username: String) -> NSString? {
        return self.load(service: serviceValue as NSString, account: username as NSString)
    }
    
    private func save(service: NSString, account: NSString, data: NSString) {
        
        let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData
        let accountFromString: NSData = account.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData
        
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, accountFromString, dataFromString],
                                                                     forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        SecItemDelete(keychainQuery as CFDictionary)
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private func load(service: NSString, account: NSString) -> NSString? {

        let accountFromString: NSData = account.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData
        
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, accountFromString, kCFBooleanTrue, kSecMatchLimitOneValue],
                                                                     forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var data: AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &data)
        var contentsOfKeychain: NSString? = nil
        
        if status == errSecSuccess {
            if let retrievedData = data as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        } else {
            print("Nothing was retrieved from keychain.")
        }
        return contentsOfKeychain
    }
    
}








