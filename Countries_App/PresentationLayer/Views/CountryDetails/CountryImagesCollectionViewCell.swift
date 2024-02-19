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
        
        imageLoading(with: images, flagURL: flagURL, numberOfPages: numberOfPages, imageIndex: imageIndex)
    }
    
    // MARK: - Private functions
    
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                print("Image was not loaded:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.countryImagesImageView.image = UIImage(named: self.noImage)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.countryImagesImageView.image = UIImage(named: self.noImage)
                }
                return
            }
            
            if data.isEmpty {
                let placeholderImage = UIImage(named: self.noImage) ?? UIImage()
                ImageCache.shared.setImage(placeholderImage, forKey: url.absoluteString)
                DispatchQueue.main.async {
                    self.countryImagesImageView.contentMode = .scaleToFill
                    self.countryImagesImageView.image = placeholderImage
                }
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
    
    private func imageLoading(with images: String, flagURL: String, numberOfPages: Int, imageIndex: Int) {
        if images.isEmpty {
            guard !flagURL.isEmpty, let flagURL = URL(string: flagURL) else {
                DispatchQueue.main.async {
                    self.countryImagesImageView.image = UIImage(named: self.noImage)
                    self.pageControl.isHidden = true
                }
                return
            }
            
            if let cachedImage = ImageCache.shared.getImage(forKey: flagURL.absoluteString) {
                self.countryImagesImageView.image = cachedImage
                self.countryImagesImageView.contentMode = .scaleToFill
            } else {
                downloadImage(from: flagURL)
            }
            self.pageControl.isHidden = true
        }
        
        else {
            guard let imageURL = URL(string: images) else {
                return
            }
            
            if let cachedImage = ImageCache.shared.getImage(forKey: imageURL.absoluteString) {
                self.countryImagesImageView.image = cachedImage
                self.countryImagesImageView.contentMode = .scaleToFill
            } else {
                downloadImage(from: imageURL)
            }
            DispatchQueue.main.async {
                self.pageControl.numberOfPages = numberOfPages
                self.pageControl.currentPage = imageIndex
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
