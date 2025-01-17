//
//  NetworkManager.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/11/25.
//

import Foundation


/// Network client that performs primary communication with the remote server.
final class NetworkManager: NetworkSession {
    
    let validURL: URL? = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
    
    /// Performs a GET URLSession call to fetch recipe data from the server.
    /// - Returns: An array of Recipe.
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = validURL else {
            throw NetworkErrors.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkErrors.invalidResponse
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            throw NetworkErrors.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(Response.self, from: data)
            return response.recipes
        } catch {
            print("ERROR: \(error)")
            throw NetworkErrors.decodingError
        }
    }
}
