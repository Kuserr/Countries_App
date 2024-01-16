//
//  CountryCollectionViewCell.swift
//  Countries_App
//
//  Created by Сергей Курьян on 14.01.2024.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    
    static let reuseId = "CountryCollectionViewCell"
  
    func configure(with country: Country) {
        countryLabel.text = country.name
        capitalLabel.text = country.capital
        descriptionLabel.text = country.descriptionSmall

        // Load image from URL
        if let imageUrl = URL(string: country.countryInfo.flag) {
            downloadImage(from: imageUrl)
            } else {
                imageLabel.image = UIImage(named: "abh")
            }
        }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame

        return layoutAttributes
    }

        override var intrinsicContentSize: CGSize {
            return CGSize(width: UIView.noIntrinsicMetric, height: 1)
        }
    
    // MARK: - Private
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageLabel.image = image
                    if let collectionView = self.superview as? UICollectionView {
                                            collectionView.collectionViewLayout.invalidateLayout()
                                        }
                }
            } else {
                DispatchQueue.main.async {
                    self.imageLabel.image = UIImage(named: "abh")
                }
            }
        }.resume()
    }
}
