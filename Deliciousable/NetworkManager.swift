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

final class NetworkManager {
    
    let url: URL?
    init (url: URL?) {
        self.url = url
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url else {
            throw NetworkErrors.baseURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(Response.self, from: data)
            print(response)
            return response.recipes
        } catch {
            print("ERROR: \(error)")
            throw NetworkErrors.baseURL
        }
    }
}
