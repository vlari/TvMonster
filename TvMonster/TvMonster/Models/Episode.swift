//
//  Episode.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation

struct Episode: Decodable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String?
    let season: Int
    let number: Int
    let summary: String?
    let image: MediaImage?
    let rating: ShowRating?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

struct MediaImage: Decodable, Equatable {
    let medium: String?
    let original: String?
    
    func getValidImage() -> String {
        if let mediumImage = medium {
            return mediumImage
        }
        
        if let originalImage = original {
            return originalImage
        }
        
        return "tvplaceholder"
    }
}
