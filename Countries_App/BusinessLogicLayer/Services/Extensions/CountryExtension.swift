//
//  CountryExtension.swift
//  Countries_App
//
//  Created by Сергей Курьян on 21.02.2024.
//

import Foundation
import UIKit

protocol CountryRepresentable {
    var descriptionSmall: String { get }
    var textHeight: CGFloat { get }
}

extension CountryRepresentable {
    private func estimateTextHeight(_ text: String, width: CGFloat) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16)
        ]
        let boundingBox = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                              options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                              attributes: attributes,
                                                              context: nil)
        return ceil(boundingBox.height)
    }
    
    var textHeight: CGFloat {
        let widthLayout = CGFloat(5)
        let width = UIScreen.main.bounds.width - widthLayout
        let minHeight: CGFloat = 230
        let text = descriptionSmall
        let textHeight = estimateTextHeight(text, width: width)
        
        guard textHeight.isFinite else {
            print("Invalid textHeight")
            return minHeight
        }
        
        return max(minHeight, textHeight)
    }
}
