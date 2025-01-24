//
//  MockCachedImageManager.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/17/25.
//

import UIKit
@testable import Deliciousable


class MockCachedImageManager: NSObject {
    
    var image: UIImage?
    
    func loadImage(fromURL url: URL, usingKey cacheKey: String) async throws {
        if let cachedImage = ImageCache.shared.getImage(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        do {
            if let data = UIImage(named: "DeliciousableIcon")?.pngData(),
               let fetchedImage = UIImage(data: data) {
                ImageCache.shared.setImage(fetchedImage, forKey: cacheKey)
                self.image = fetchedImage
            }
        }
    }
}
