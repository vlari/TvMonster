//
//  UIApplication+Extension.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
