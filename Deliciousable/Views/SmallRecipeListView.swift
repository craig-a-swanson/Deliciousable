//
//  SmallRecipeListView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/16/25.
//

import SwiftUI


struct SmallRecipeListView: View {
    
    @Binding var filteredRecipes: [Recipe]
    @Binding var isPortraitMode: Bool
    @Binding var selectedRecipe: Recipe?
    
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
                .frame(width: 60, height: 60)
            VStack(alignment: .leading){
                if recipe.sourceUrl != nil {
                    Text("\(recipe.name)")
                        .foregroundStyle(Color.blue)
                        .onTapGesture {
                            selectedRecipe = recipe
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
}
