//
//  UILabelFactory.swift
//  CoinCo
//
//  Created by Güray Gül on 5.05.2024.
//

import UIKit

final class UILabelFactory {
    private let label: UILabel
    private let defultFontSize: CGFloat = 20
      
    // MARK: - Inits
    init(text: String) {
      label = UILabel()
      label.textAlignment = .left
      label.text = text
      label.font = label.font.withSize(defultFontSize)
      label.translatesAutoresizingMaskIntoConstraints = false
    }
      
    // MARK: - Public methods
    func fontSize(of size: CGFloat, weight: UIFont.Weight) -> Self {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        label.font = font
        return self
    }

      
    func textColor(with color: UIColor) -> Self {
      label.textColor = color
          
      return self
    }
      
    func numberOf(lines: Int) -> Self {
      label.numberOfLines = lines
          
      return self
    }
      
    func build() -> UILabel {
      return label
    }
}
