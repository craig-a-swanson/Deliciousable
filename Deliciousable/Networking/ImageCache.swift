//
//  ImageCache.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/14/25.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()

    private init() {}

    private let cache = NSCache<NSString, UIImage>()
    
    func getImage(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
