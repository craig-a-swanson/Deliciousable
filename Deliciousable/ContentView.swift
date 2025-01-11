//
//  ContentView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewManager = ViewManager()
    @State var recipes: [Recipe]?
    
    var body: some View {
        ZStack {
            if let recipes {
                ScrollView {
                    ForEach(recipes, id: \.id) { recipe in
                        HStack {
                            Text("\(recipe.name)")
                            Text(("\(recipe.cuisine.rawValue)"))
                        }
                    }
                }
                .padding()
            }
        }
        .task {
            self.recipes = try? await viewManager.networkManager.fetchRecipes()
            
        }
    }
}
