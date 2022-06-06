//
//  String+Extension.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation

extension String {
    var stripHTML: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
