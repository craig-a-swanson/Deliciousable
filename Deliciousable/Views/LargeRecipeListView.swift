//
//  LargeRecipeListView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/16/25.
//

import SwiftUI


struct LargeRecipeListView: View {
    
    @EnvironmentObject var viewModel: RecipeViewModel
    @Binding var filteredRecipes: [Recipe]
    @Binding var isPortraitMode: Bool
    @Binding var selectedRecipe: Recipe?
    @Binding var selectedVideo: Recipe?
    
    var gridItems: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        if isPortraitMode {
            List(filteredRecipes, id: \.id) { recipe in
                createContentView(with: recipe)
            }
        } else {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 12) {
                    ForEach(filteredRecipes, id:\.id) { recipe in
                        createContentView(with: recipe)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .cornerRadius(10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            }
                    }
                }
                .padding()
            }
        }
    }
    
    private func createContentView(with recipe: Recipe) -> some View {
        HStack {
            CachedImageView(recipe: recipe)
                .frame(width: 120, height: 120)
            VStack(alignment: .leading){
                Text("\(recipe.name)")
                    .font(.headline)
                Text(("\(recipe.cuisine.rawValue)"))
                    .font(.subheadline)
                if recipe.sourceUrl != nil {
                    Text("Link to recipe.")
                        .font(.caption.italic())
                        .foregroundStyle(Color.blue)
                        .padding(.top, 4)
                        .onTapGesture {
                            selectedRecipe = recipe
                        }
                }
                if recipe.youtubeUrl != nil {
                    Text("Link to video.")
                        .font(.caption.italic())
                        .foregroundStyle(Color.blue)
                        .padding(.vertical, 2)
                        .onTapGesture {
                            selectedVideo = recipe
                        }
                }
            }
            Spacer()
        }
    }
}
