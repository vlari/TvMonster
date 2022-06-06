//
//  FormatterManager.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation

class FormatterManager {
    static let shared = FormatterManager()
    
    func getRating(rating: Double?) -> String {
        guard let rating = rating else {
            return "-"
        }
        
        return String(rating)
    }
    
    func getYear(from date: String?) -> String {
        guard let date = date else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: date) else {
            return ""
        }

        dateFormatter.dateFormat = "yyyy"
        return  dateFormatter.string(from: date)
    }
    
}
