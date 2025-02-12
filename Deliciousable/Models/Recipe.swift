//
//  Recipe.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/11/25.
//

import Foundation

/// The response from the backend.
struct Response: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    let cuisine: Cuisine
    let name: String
    let imageUrl: URL?
    let thumbnailUrl: URL?
    let sourceUrl: URL?
    let id: String
    let youtubeUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case cuisine, name, sourceUrl, youtubeUrl
        case imageUrl = "photoUrlLarge"
        case thumbnailUrl = "photoUrlSmall"
        case id = "uuid"
    }
    
    var cacheKey: String { id } // For clarity, create a 'cacheKey' property that is simply the object's id.
}
