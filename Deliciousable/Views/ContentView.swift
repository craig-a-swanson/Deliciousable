//
//  ContentView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: RecipeViewModel
    @State private var selectedRecipe: Recipe?
    @State private var selectedVideo: Recipe?
    @State private var isSmallListView = true
    @State private var isPortraitMode = UIDevice.current.orientation == .portrait
    @State private var selectedCuisines: Set<Cuisine> = []
    @State private var filteredRecipes: [Recipe] = []
    
    @State private var showCuisineFilterView = false
    @State private var showWebView = false
    @State private var showAlert = false
    @State private var showInfoSheet = false
    @State private var showEmptyState = false
    
    init() {
        _viewModel = StateObject(wrappedValue: RecipeViewModel(networkManager: NetworkManager()))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if showEmptyState {
                    EmptyStateView(showEmptyState: $showEmptyState, showAlert: $showAlert)
                } else if isSmallListView {
                    SmallRecipeListView(filteredRecipes: $filteredRecipes, isPortraitMode: $isPortraitMode, selectedRecipe: $selectedRecipe)
                } else {
                    LargeRecipeListView(filteredRecipes: $filteredRecipes, isPortraitMode: $isPortraitMode, selectedRecipe: $selectedRecipe, selectedVideo: $selectedVideo)
                }
            }
            .navigationTitle("Today's Recipes")
            .toolbar {
                createToolbarItems()
            }
            .refreshable {
                do {
                    try await viewModel.fetchRecipes()
                    self.showEmptyState = viewModel.recipes.isEmpty
                } catch {
                    withAnimation {
                        self.showAlert = true
                    }
                }
            }
            .onChange(of: selectedCuisines) { _ in
                if selectedCuisines.isEmpty {
                    filteredRecipes = viewModel.recipes
                }
                filteredRecipes = viewModel.recipes.filter { selectedCuisines.contains($0.cuisine) }
            }
            // Receive a notification when the devices changes between portrait and landscape.
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
                self.isPortraitMode = UIDevice.current.orientation == .portrait
            })
        }
        // Complete a call to fetch the recipes when the view is loaded.
        .task {
            do {
                try await viewModel.fetchRecipes()
                self.showEmptyState = viewModel.recipes.isEmpty
                self.filteredRecipes = viewModel.recipes
            } catch {
                self.showAlert = true
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
                .presentationDragIndicator(.visible)
            }
        })
        .sheet(item: $selectedVideo, onDismiss: {
            self.selectedVideo = nil
        }, content: { recipe in
            if let youtubeURL = recipe.youtubeUrl {
                WebView(recipeURL: youtubeURL)
                    .presentationDragIndicator(.visible)
            }
        })
        .sheet(isPresented: $showCuisineFilterView) {
            FilterView(selectedCuisines: $selectedCuisines)
        }
        .sheet(isPresented: $showInfoSheet) {
            VStack(spacing: 25) {
                Text("Created by Craig Swanson")
                    .font(.callout.italic())
                Text("App Icon by by Flatart on freeicons.io")
                    .font(.caption)
            }
            .frame(maxHeight: 300)
            .padding()
            .presentationDetents([.fraction(0.25), .medium])
            .presentationDragIndicator(.visible)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Data Error"), message: Text("There is an issue with the server data. Please try again later."), dismissButton: .default(Text("OK")))
        }
        .environmentObject(viewModel)
    }
    
    private func createToolbarItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            // Insert toolbar button for the list view type.
            Button {
                withAnimation {
                    isSmallListView.toggle()
                }
            } label: {
                Image(systemName: isSmallListView ? "list.dash" : "rectangle.grid.1x2")
            }
            
            Spacer()
            
            // Insert toolbar button to filter on cuisine.
            Button {
                showCuisineFilterView = true
            } label: {
                Image(systemName: "globe")
            }
            
            // Insert an information button.
            Button {
                showInfoSheet = true
            } label: {
                Image(systemName: "info.circle")
            }
        }
    }
}
