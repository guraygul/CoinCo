//
//  UIImageViewFactory.swift
//  CoinCo
//
//  Created by Güray Gül on 9.05.2024.
//

import UIKit

final class UIImageViewFactory {
    private let imageView: UIImageView
    
    // MARK: - Inits
    init(image: UIImage? = nil) {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Public methods
    func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        imageView.contentMode = contentMode
        return self
    }
    
    func image(_ image: UIImage?) -> Self {
        imageView.image = image
        return self
    }
    
    func tintColor(_ color: UIColor) -> Self {
        imageView.tintColor = color
        return self
    }
    
    func build() -> UIImageView {
        return imageView
    }
}
