//
//  UIStackViewFactory.swift
//  CoinCo
//
//  Created by Güray Gül on 9.05.2024.
//

import UIKit

final class UIStackViewFactory {
    private let stackView: UIStackView
    
    // MARK: - Inits
    init(axis: NSLayoutConstraint.Axis) {
        stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Public methods
    func addArrangedSubview(_ view: UIView) -> Self {
        stackView.addArrangedSubview(view)
        return self
    }
    
    func alignment(_ alignment: UIStackView.Alignment) -> Self {
        stackView.alignment = alignment
        return self
    }
    
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
        stackView.distribution = distribution
        return self
    }
    
    func spacing(_ spacing: CGFloat) -> Self {
        stackView.spacing = spacing
        return self
    }
    
    func build() -> UIStackView {
        return stackView
    }
}

