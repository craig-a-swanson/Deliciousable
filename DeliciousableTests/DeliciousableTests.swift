//
//  DeliciousableTests.swift
//  DeliciousableTests
//
//  Created by Craig Swanson on 1/10/25.
//

import UIKit
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
            expectedError = NetworkErrors.decodingError
        }
        #expect(expectedError == .decodingError)
    }
    
    @Test("Image Already in Cache is Retrieved From Cache")
    func imageCacheImageIsValid() async throws {
        let testImageKey = "TestImageKey"
        let testImage = try #require(UIImage(systemName: "globe"))
        ImageCache.shared.setImage(testImage, forKey: testImageKey)
        
        let mockCacheManager = MockCachedImageManager()
        
        do {
            try await mockCacheManager.loadImage(fromURL: URL(string: "https://www.google.com")!, usingKey: testImageKey)
        } catch {
            Issue.record(error, "Error in loading image with Mock Loader.")
        }
        
        #expect(mockCacheManager.image == testImage)
    }
    
    @Test("Image Not In Cache Is Fetched and Set To Cache")
    func emptyCacheUsesNetwork() async throws {
        let testImageKey2 = "TestImageKey2"
        let mockCacheManager = MockCachedImageManager()
        
        do {
            try await mockCacheManager.loadImage(fromURL: URL(string: "https://www.google.com")!, usingKey: testImageKey2)
        } catch {
            Issue.record(error, "Error in loading image with Mock Loader.")
        }
        
        let mockImage = try #require(mockCacheManager.image)
        let cachedImage = ImageCache.shared.getImage(forKey: testImageKey2)
        #expect(mockImage == cachedImage)
    }
}
