//
//  DeliciousableTests.swift
//  DeliciousableTests
//
//  Created by Craig Swanson on 1/10/25.
//

import Testing
@testable import Deliciousable

struct DeliciousableTests {
    
    @Test("Fetch all recipes")
    func fetchValidRecipes() async throws {
        let mockNetwork = MockNetworkManager()
        mockNetwork.validity = .valid
        let viewModel = RecipeViewModel(networkManager: mockNetwork)
        var recipes: [Recipe] = []
        
        do {
            try await viewModel.fetchRecipes()
            recipes = viewModel.recipes
        } catch {
            Issue.record(error, "Error in view model fetching valid JSON")
        }
        #expect(recipes.count == 7)
    }
    
    @Test("Fetch invalid recipe payload")
    func fetchInvalidRecipes() async throws {
        let mockNetwork = MockNetworkManager()
        mockNetwork.validity = .invalid
        let viewModel = RecipeViewModel(networkManager: mockNetwork)
        var expectedError: NetworkErrors? = nil
        
        do {
            try await viewModel.fetchRecipes()
        } catch {
            expectedError = NetworkErrors.baseURL
        }
        #expect(expectedError == .baseURL)
    }
}
