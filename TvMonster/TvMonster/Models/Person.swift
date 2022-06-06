//
//  Person.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import Foundation

struct PersonResponse: Decodable {
    let score: Double
    let person: Person
}

struct Person: Decodable, Identifiable {
    let id: Int
    let name: String
    let image: MediaImage?
    let country: PersonalDetail?
}

struct PersonalDetail: Decodable {
    let name: String?
}
