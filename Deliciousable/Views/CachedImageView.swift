//
//  CachedImageView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/14/25.
//

import SwiftUI


/// Provides a view with the cached image, if available, or initiates a load of the image if it is not yet in cache.
struct CachedImageView: View {
    
    let recipe: Recipe
    @StateObject private var imageLoader = CachedImageManager()
    @State private var showNoImageFound = false
    
    var body: some View {
        Group {
            // Set the view to the cached image if it's available.
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
            } else if showNoImageFound {
                // If an image is not fetched, use the app icon as a placeholder.
                Image(uiImage: UIImage(named: "DeliciousableIcon") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                
            } else {
                // Load the image if it is not yet cached.
                if let validURL = recipe.thumbnailUrl {
                    ProgressView()
                        .task {
                            do {
                                try await imageLoader.loadImage(fromURL: validURL, usingKey: recipe.cacheKey)
                            } catch {
                                print(error)
                                showNoImageFound = true
                            }
                        }
                }
            }
        }
    }
}
