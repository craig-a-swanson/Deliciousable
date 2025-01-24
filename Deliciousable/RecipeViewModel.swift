//
//  RecipeViewModel.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/11/25.
//

import SwiftUI

final class RecipeViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    private let networkManager: any NetworkSession
    
    /// Initializer used to inject either a true network manager or a mock manager for testing.
    /// - Parameter networkManager: Class that conforms to NetworkSession protocol.
    init(networkManager: any NetworkSession) {
        self.networkManager = networkManager
    }
    
    /// Method used to fetch recipes from the remote server.
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
