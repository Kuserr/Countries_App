//
//  ImageCache.swift
//  Countries_App
//
//  Created by Сергей Курьян on 15.02.2024.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()

    let cache = NSCache<NSString, UIImage>()

    private init() {}

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
