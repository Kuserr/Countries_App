//
//  CountryCollectionViewCell.swift
//  Countries_App
//
//  Created by Сергей Курьян on 14.01.2024.
//

import UIKit

final class CountryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private properties
    
    private let noImage = "no_image_placeholder"
    
    // MARK: - CollectionViewCell configuration
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak private var flagImageView: UIImageView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var countryLabel: UILabel!
    @IBOutlet weak private var capitalLabel: UILabel!
    
    func configure(with country: Country) {
        countryLabel.text = country.name
        capitalLabel.text = country.capital
        descriptionLabel.text = country.descriptionSmall
        
        imageLoading(with: country)
    }
    
    func configure(with countryEntity: CountryEntity) {
        countryLabel.text = countryEntity.name
        capitalLabel.text = countryEntity.capital
        descriptionLabel.text = countryEntity.descriptionSmall
        
        imageLoadingForDB(with: countryEntity)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        flagImageView.image = nil
        descriptionLabel.text = nil
        countryLabel.text = nil
        capitalLabel.text = nil
        
        super.prepareForReuse()
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 1)
    }
    
    // MARK: - Private functions
    
    private func downloadImage(from url: URL) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                ImageCache.shared.setImage(image, forKey: url.absoluteString)
                DispatchQueue.main.async {
                    self.flagImageView.image = image
                }
            } else {
                ImageCache.shared.setImage(UIImage(named: self.noImage) ?? UIImage(), forKey: url.absoluteString)
                DispatchQueue.main.async {
                    self.flagImageView.image = UIImage(named: self.noImage)
                }
            }
        }.resume()
    }
    
    private func imageLoading(with country: Country) {
        guard let imageUrl = URL(string: country.countryInfo.flag) else {
            return
        }
        guard let cachedImage = ImageCache.shared.getImage(forKey: imageUrl.absoluteString) else {
            return downloadImage(from: imageUrl)
        }
        DispatchQueue.main.async {
            self.flagImageView.image = cachedImage
        }
    }
    
    private func imageLoadingForDB(with country: CountryEntity) {
        guard let imageUrl = URL(string: country.flag) else {
            return
        }
        guard let cachedImage = ImageCache.shared.getImage(forKey: imageUrl.absoluteString) else {
            return downloadImage(from: imageUrl)
        }
        DispatchQueue.main.async {
            self.flagImageView.image = cachedImage
        }
    }
}
