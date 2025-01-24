//
//  CachedImageManager.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/14/25.
//

import SwiftUI

/// Observable Object class that, in conjunction with ImageCache, will either return the cached image or fetch the image from the server and save it to cache.
@MainActor
class CachedImageManager: ObservableObject {
    @Published var image: UIImage?
    
    func loadImage(fromURL url: URL, usingKey cacheKey: String) async throws {
        
        if let cachedImage = ImageCache.shared.getImage(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let fetchedImage = UIImage(data: data) {
                ImageCache.shared.setImage(fetchedImage, forKey: cacheKey)
                self.image = fetchedImage
            }
        } catch {
            throw NetworkErrors.fetchDataError
        }
    }
}
