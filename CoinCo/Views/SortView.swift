//
//  SortView.swift
//  CoinCo
//
//  Created by Güray Gül on 9.05.2024.
//

import UIKit

protocol SortViewDelegate: AnyObject {
    func showSortOptions()
}

final class SortView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
    weak var delegate: SortViewDelegate?
    
    private lazy var sortHStack = UIStackViewFactory(axis: .horizontal)
        .addArrangedSubview(rankingListLabel)
        .addArrangedSubview(sortButton)
        .distribution(.equalSpacing)
        .alignment(.center)
        .build()
    
    private let rankingListLabel = UILabelFactory(text: "Ranking List")
        .fontSize(of: 24, weight: .semibold)
        .textColor(with: Theme.accentWhite)
        .build()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sort By", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Theme.tintColor
        button.layer.cornerRadius = 20
        
        if let downImage = UIImage(systemName: "arrow.down") {
            button.setImage(downImage, for: .normal)
            button.tintColor = .white
        }
        
        var configuration = UIButton.Configuration.plain()
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        button.configuration = configuration
        
        button.addTarget(self, action: #selector(showSortOptions), for: .touchUpInside)
        return button
    }()
    
    @objc func showSortOptions() {
        delegate?.showSortOptions()
    }
    
    private func setupConstraints() {
        super.layoutSubviews()
        
        backgroundColor = Theme.backgroundColor
        layer.cornerRadius = 30
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addSubview(sortHStack)
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sortHStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sortHStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortHStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            rankingListLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sortButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
