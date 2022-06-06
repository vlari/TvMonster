//
//  CreditResponse.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import Foundation

struct CreditResponse: Decodable {
    let embedded: EmbeddedCreditData
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct EmbeddedCreditData: Decodable {
    let show: CreditShow
}

struct CreditShow: Decodable, Identifiable {
    let id: Int
    let name: String?
    let image: MediaImage?
    let url: String?
}
