//
//  RecipeViewModel.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/11/25.
//

import SwiftUI

protocol NetworkSession {
    func fetchRecipes() async throws -> [Recipe]
}

final class RecipeViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    private let networkManager: any NetworkSession
    
    init(networkManager: any NetworkSession) {
        self.networkManager = networkManager
    }
    
    @MainActor
    func fetchRecipes() async throws {
        do {
            self.recipes = try await networkManager.fetchRecipes()
            
        } catch {
            print(error)
            throw error
        }
    }
    
}
