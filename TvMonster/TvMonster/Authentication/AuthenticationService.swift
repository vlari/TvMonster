//
//  AuthenticationService.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import Foundation
import SwiftUI

class AuthenticationService: ObservableObject {
  var isPinBlank: Bool {
      getStoredPin() == ""
  }
    
  func getStoredPin() -> String {
    let authManager = AuthenticationManager()
    if let pin = try? authManager.getPinFor(account: "TvMonster", service: "authService") {
      return pin
    }

    return ""
  }
    
  func updateStoredPin(_ pin: String) {
      let authManager = AuthenticationManager()
      
    do {
        try authManager.storeGenericPinFor(account: "TvMonster",
                                           service: "authService",
                                           password: pin)
    } catch let error as AuthenticationError {
      print("Exception setting pin: \(error.message ?? "no message")")
    } catch {
      print("An error occurred while setting the pin.")
    }
  }

  func validatePin(_ pin: String) -> Bool {
    let currentPin = getStoredPin()
    return pin == currentPin
  }

  func changePin(currentPin: String, newPin: String) -> Bool {
    guard validatePin(currentPin) == true else { return false }
      updateStoredPin(newPin)
    return true
  }
    
}
