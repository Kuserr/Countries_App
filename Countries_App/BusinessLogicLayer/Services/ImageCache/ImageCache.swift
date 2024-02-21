//
//  ImageCache.swift
//  Countries_App
//
//  Created by Сергей Курьян on 15.02.2024.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    typealias CacheType = NSCache<NSString, UIImage>
    
    private lazy var cache: CacheType = {
        let cache = CacheType()
        cache.countLimit = 100
        cache.totalCostLimit = 300 * 1024 * 1024 // 300 MB
        return cache
    }()

    private init() {}

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func clearAllData() {
        cache.removeAllObjects()
    }
}
