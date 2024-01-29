//
//  LoaderCollectionViewCell.swift
//  Countries_App
//
//  Created by Сергей Курьян on 17.01.2024.
//

import UIKit

class LoaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let reuseId = "LoaderCollectionViewCell"

    func startAnimating() {
            activityIndicator.startAnimating()
        }
        
    func stopAnimating() {
            activityIndicator.stopAnimating()
        }
}
