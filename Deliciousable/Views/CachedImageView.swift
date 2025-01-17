//
//  CachedImageView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/14/25.
//

import SwiftUI

struct CachedImageView: View {
    
    let recipe: Recipe
    @StateObject private var imageLoader = CachedImageManager()
    @State private var showNoImageFound = false
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if showNoImageFound {
                Image(uiImage: UIImage(named: "appIcon") ?? UIImage())
                    .resizable()
                    .scaledToFit()
            } else {
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
