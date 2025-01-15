//
//  NetworkManager.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/11/25.
//

import Foundation

enum NetworkErrors: Error {
    case baseURL
}

final class NetworkManager: NetworkSession {
    
    let validURL: URL? = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")

    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = validURL else {
            throw NetworkErrors.baseURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(Response.self, from: data)
            return response.recipes
        } catch {
            print("ERROR: \(error)")
            throw NetworkErrors.baseURL
        }
    }
}
