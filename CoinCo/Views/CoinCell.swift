//
//  CoinCell.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import UIKit

class CoinCell: UITableViewCell {

    static let identifier = "CoinCell"

    // MARK: - Variables
    
    private(set) var coin: Coin!
    
    // MARK: - UI Components
    
    private let coinLogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .black
        iv.backgroundColor = .systemBlue
        return iv
    }()
    
    private let coinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
    
    public func configure(with coin: Coin) {
        self.coin = coin
        
        self.coinLabel.text = coin.name
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        self.addSubview(coinLogo)
        self.addSubview(coinLabel)
        
        coinLogo.translatesAutoresizingMaskIntoConstraints = false
        coinLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coinLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            coinLogo.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            coinLogo.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
            coinLogo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
            
            coinLabel.leadingAnchor.constraint(equalTo: coinLogo.trailingAnchor, constant: 16),
            coinLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
