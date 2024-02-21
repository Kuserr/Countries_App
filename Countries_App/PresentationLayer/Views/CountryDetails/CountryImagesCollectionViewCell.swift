//
//  CountryImagesCollectionViewCell.swift
//  Countries_App
//
//  Created by Сергей Курьян on 01.02.2024.
//

import UIKit

final class CountryImagesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private properties
    
    private let noImage = "no_image_placeholder"
    @IBOutlet weak private var countryImagesImageView: UIImageView!
    @IBOutlet weak private var pageControl: UIPageControl!
    
    // MARK: - Cell configuration
    
    func configure(with images: String, flagURL: String, numberOfPages: Int, imageIndex: Int) {
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        
        imageLoading(with: images, flag: flagURL, numberOfPages: numberOfPages, imageIndex: imageIndex)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countryImagesImageView.image = nil
        
    }
    
    // MARK: - Private functions
    
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                print("Image was not loaded:", error.localizedDescription)
                self.showImagePlaceholder()
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                self.showImagePlaceholder()
                return
            }
            
            if data.isEmpty {
                self.showImagePlaceholder()
            } else {
                ImageCache.shared.setImage(image, forKey: url.absoluteString)
                DispatchQueue.main.async {
                    self.countryImagesImageView.contentMode = .scaleToFill
                    self.countryImagesImageView.image = image
                }
            }
        }
        .resume()
    }
    
    private func imageLoading(with images: String, flag: String, numberOfPages: Int, imageIndex: Int) {
        guard !images.isEmpty, let imagesURL = URL(string: images) else {
            if !flag.isEmpty, let flagURL = URL(string: flag) {
                getFromCacheOrDownload(image: flag, imageURL: flagURL)
                self.pageControl.isHidden = true
            } else {
                DispatchQueue.main.async {
                    self.countryImagesImageView.image = UIImage(named: self.noImage)
                    self.pageControl.isHidden = true
                }
            }
            return
        }
        
        getFromCacheOrDownload(image: images, imageURL: imagesURL)
        DispatchQueue.main.async {
            self.pageControl.numberOfPages = numberOfPages
            self.pageControl.currentPage = imageIndex
        }
    }
    
    private func getFromCacheOrDownload(image key: String, imageURL: URL) {
        if let cachedImages = ImageCache.shared.getImage(forKey: key) {
            self.countryImagesImageView.image = cachedImages
            self.countryImagesImageView.contentMode = .scaleToFill
        } else {
            downloadImage(from: imageURL)
        }
    }
    
    private func showImagePlaceholder() {
        DispatchQueue.main.async {
            self.countryImagesImageView.contentMode = .scaleToFill
            self.countryImagesImageView.image = UIImage(named: self.noImage)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
