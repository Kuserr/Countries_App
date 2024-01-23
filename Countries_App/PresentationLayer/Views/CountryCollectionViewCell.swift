//
//  CountryCollectionViewCell.swift
//  Countries_App
//
//  Created by Сергей Курьян on 14.01.2024.
//

import UIKit

final class CountryCollectionViewCell: UICollectionViewCell {
    
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
        
        if let imageUrl = URL(string: country.countryInfo.flag) {
            downloadImage(from: imageUrl)
        } else {
            flagImageView.image = UIImage(named: self.noImage)
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 1)
    }
    
    // MARK: - Private functions and properties
    
    private let noImage = "no_image_placeholder"
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.flagImageView.image = image
                }
            } else {
                self.flagImageView.image = UIImage(named: self.noImage)
            }
        }.resume()
    }
}
