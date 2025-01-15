//
//  ContentView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = RecipeViewModel(networkManager: NetworkManager())
    @State private var showWebView = false
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        NavigationStack {
                List(viewModel.recipes, id: \.id) { recipe in
                    HStack {
                        CachedImageView(recipe: recipe)
                            .frame(width: 60, height: 60)
                        VStack(alignment: .leading){
                            if recipe.sourceUrl != nil {
                                Text("\(recipe.name)")
                                    .foregroundStyle(Color.secondary)
                                    .onTapGesture {
                                        self.selectedRecipe = recipe
                                    }
                            } else {
                                Text("\(recipe.name)")
                            }
                            Text(("\(recipe.cuisine.rawValue)"))
                                .font(.caption2.italic())
                        }
                        Spacer()
                    }
                }
                .navigationTitle("Today's Recipes")
                .refreshable {
                    do {
                        try await viewModel.fetchRecipes()
                    } catch {
                        // TODO: display error
                    }
                }
        }
        .task {
            do {
                try await viewModel.fetchRecipes()
            } catch {
                // TODO: display error in UI
            }
        }
        .sheet(item: $selectedRecipe, onDismiss: {
            self.selectedRecipe = nil
        }, content: { recipe in
            if let recipeURL = recipe.sourceUrl {
                NavigationStack {
                    WebView(recipeURL: recipeURL)
                        .ignoresSafeArea()
                        .navigationTitle("Selected Recipe")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        })
    }
    
    private func openWebView(for recipe: Recipe) {
        self.selectedRecipe = recipe
        self.showWebView = true
    }
}
