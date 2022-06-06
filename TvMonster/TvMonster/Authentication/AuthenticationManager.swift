//
//  AuthenticationService.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import Foundation

class AuthenticationManager {
    
    func storeGenericPinFor(account: String, service: String, password: String) throws {
        if password.isEmpty {
            try deletePinFor(account: account, service: service)
            
            return
        }
        
        guard let passwordData = password.data(using: .utf8) else {
            print("Error converting value to data.")
            throw AuthenticationError(type: .badData)
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            break
        case errSecDuplicateItem:
            try updatePinFor(account: account, service: service, password: password)
        default:
            throw AuthenticationError(status: status, type: .servicesError)
        }
    }
    
    func getPinFor(account: String, service: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw AuthenticationError(type: .itemNotFound)
        }
        guard status == errSecSuccess else {
            throw AuthenticationError(status: status, type: .servicesError)
        }
        guard let existingItem = item as? [String: Any],
              let valueData = existingItem[kSecValueData as String] as? Data,
              let value = String(data: valueData, encoding: .utf8)
        else {
            throw AuthenticationError(type: .unableToConvertToString)
        }
        
        return value
    }
    
    func updatePinFor(account: String, service: String, password: String) throws {
        guard let passwordData = password.data(using: .utf8) else {
            print("Error converting value to data.")
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else {
            throw AuthenticationError(message: "Matching Item Not Found", type: .itemNotFound)
        }
        guard status == errSecSuccess else {
            throw AuthenticationError(status: status, type: .servicesError)
        }
    }
    
    func deletePinFor(account: String, service: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AuthenticationError(status: status, type: .servicesError)
        }
    }
    
}
