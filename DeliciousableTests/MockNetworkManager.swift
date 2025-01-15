//
//  MockNetworkManager.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/13/25.
//

import Foundation
@testable import Deliciousable

class MockNetworkManager: NetworkSession {
    
    enum Validity {
        case valid, invalid, empty
    }
    
    var validity = Validity.valid
    
    func fetchRecipes() async throws -> [Recipe] {
        
        let resultData: Data?
        
        switch self.validity {
        case .valid:
            resultData = validJSON.data(using: .utf8)
        case .invalid:
            resultData = malformedJSON.data(using: .utf8)
        case .empty:
            resultData = emptyJSON.data(using: .utf8)
        }
        
        guard let resultData else {
            throw NetworkErrors.baseURL
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(Response.self, from: resultData)
            return response.recipes
        } catch {
            print("ERROR: \(error)")
            throw NetworkErrors.baseURL
        }
    }
}
