//
//  ContentView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: RecipeViewModel
    @State private var showWebView = false
    @State private var selectedRecipe: Recipe?
    @State private var selectedVideo: Recipe?
    @State private var isSmallListView = true
    @State private var isPortraitMode = UIDevice.current.orientation == .portrait
    @State private var selectedCuisines: Set<Cuisine> = []
    @State private var showCuisineFilterView = false
    @State private var filteredRecipes: [Recipe] = []
    
    init() {
        _viewModel = StateObject(wrappedValue: RecipeViewModel(networkManager: NetworkManager()))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if isSmallListView {
                    SmallRecipeListView(filteredRecipes: $filteredRecipes, isPortraitMode: $isPortraitMode, selectedRecipe: $selectedRecipe)
                } else {
                    LargeRecipeListView(filteredRecipes: $filteredRecipes, isPortraitMode: $isPortraitMode, selectedRecipe: $selectedRecipe, selectedVideo: $selectedVideo)
                }
            }
                .navigationTitle("Today's Recipes")
                .toolbar {
                    // Insert toolbar button for the list view type.
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            withAnimation {
                                isSmallListView.toggle()
                            }
                        } label: {
                            Image(systemName: isSmallListView ? "list.dash" : "rectangle.grid.1x2")
                        }
                    }
                    
                    // Insert toolbar button to filter on cuisine.
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            showCuisineFilterView = true
                        } label: {
                            Image(systemName: "globe")
                        }
                    }
                }
                .refreshable {
                    do {
                        try await viewModel.fetchRecipes()
                    } catch {
                        // TODO: display error
                    }
                }
                .onChange(of: selectedCuisines) { _ in
                    if selectedCuisines.isEmpty {
                        filteredRecipes = viewModel.recipes
                    }
                    filteredRecipes = viewModel.recipes.filter { selectedCuisines.contains($0.cuisine) }
                }
        }
        // Receive a notification when the devices changes between portrait and landscape.
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
            self.isPortraitMode = UIDevice.current.orientation == .portrait
        })
        // Complete a call to fetch the recipes when the view is loaded.
        .task {
            do {
                try await viewModel.fetchRecipes()
                self.filteredRecipes = viewModel.recipes
            } catch {
                // TODO: display error in UI
            }
        }
        // Present a sheet with a webview if the user selects either the recipe source link or the youtube link. We use a sheet with webview to keep the app in the foreground, otherwise it would open the link in Safari.
        .sheet(item: $selectedRecipe, onDismiss: {
            self.selectedRecipe = nil
        }, content: { recipe in
            if let recipeURL = recipe.sourceUrl {
                NavigationStack {
                    WebView(recipeURL: recipeURL)
                        .ignoresSafeArea()
                        .navigationTitle("Deliciousable: \(recipe.name)")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        })
        .sheet(item: $selectedVideo, onDismiss: {
            self.selectedVideo = nil
        }, content: { recipe in
            if let youtubeURL = recipe.youtubeUrl {
                WebView(recipeURL: youtubeURL)
            }
        })
        .sheet(isPresented: $showCuisineFilterView) {
            FilterView(selectedCuisines: $selectedCuisines)
        }
        .environmentObject(viewModel)
    }
}

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
        } else {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 12) {
                    ForEach(filteredRecipes, id:\.id) { recipe in
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
}

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
                                .padding(.top, 4)
                                .onTapGesture {
                                    selectedRecipe = recipe
                                }
                        }
                        if recipe.youtubeUrl != nil {
                            Text("Link to video.")
                                .font(.caption.italic())
                                .padding(.vertical, 2)
                                .onTapGesture {
                                    selectedVideo = recipe
                                }
                        }
                    }
                    Spacer()
                }
            }
        } else {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 12) {
                    ForEach(filteredRecipes, id:\.id) { recipe in
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
                                        .padding(.top, 4)
                                        .onTapGesture {
                                            selectedRecipe = recipe
                                        }
                                }
                                if recipe.youtubeUrl != nil {
                                    Text("Link to video.")
                                        .font(.caption.italic())
                                        .padding(.vertical, 2)
                                        .onTapGesture {
                                            selectedVideo = recipe
                                        }
                                }
                            }
                            Spacer()
                        }
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
}
