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
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
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
            DispatchQueue.main.async {
                self.countryImagesImageView.contentMode = .scaleToFill
                self.countryImagesImageView.image = image
            }
        }
        task.resume()
    }
    
    private func imageLoading(with images: String, flagURL: String, numberOfPages: Int, imageIndex: Int) {
        if images.isEmpty {
            guard !flagURL.isEmpty, let flagURL = URL(string: flagURL) else {
                return DispatchQueue.main.async {
                    self.countryImagesImageView.image = UIImage(named: self.noImage)
                    self.pageControl.isHidden = true
                }
            }
            self.pageControl.isHidden = true
            downloadImage(from: flagURL)
        }
        else {
            guard let imageURL = URL(string: images) else {
                return
            }
            downloadImage(from: imageURL)
            pageControl.numberOfPages = numberOfPages
            pageControl.currentPage = imageIndex
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
