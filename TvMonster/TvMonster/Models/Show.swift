//
//  Show.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation

struct Show: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String?
    let genres: [String]?
    let schedule: ShowSchedule?
    let summary: String?

    let rating: ShowRating?
    let image: MediaImage?
    let premiered: String?
    
    var savedId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case genres
        case schedule
        case summary
        case rating
        case image
        case premiered
    }

}

struct ShowSchedule: Decodable, Equatable {
    let time: String
    let days: [String]
}

struct ShowRating: Decodable, Equatable {
    let average: Double?
}

struct ShowSearched: Decodable {
    var show: Show
}
