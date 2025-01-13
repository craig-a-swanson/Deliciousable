//
//  ContentView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = RecipeViewModel(networkManager: NetworkManager())
    
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(viewModel.recipes, id: \.id) { recipe in
                    HStack {
                        Text("\(recipe.name)")
                        Text(("\(recipe.cuisine.rawValue)"))
                    }
                }
            }
            .padding()
        }
        .task {
            do {
                try await viewModel.fetchRecipes()
            } catch {
                // display error in UI
            }
            
        }
    }
}
