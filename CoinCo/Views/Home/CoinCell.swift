//
//  CoinCell.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import UIKit
import SDWebImage

class CoinCell: UITableViewCell {
        
    // MARK: - Variables
    
    private var coin: Coin!
    static let identifier = "CoinCell"
    
    // MARK: - UI Components
    
    private lazy var coinLabelVStack = UIStackViewFactory(axis: .vertical)
        .addArrangedSubview(coinLabel)
        .addArrangedSubview(coinShortName)
        .alignment(.leading)
        .build()
    
    private lazy var coinPriceVStack = UIStackViewFactory(axis: .vertical)
        .addArrangedSubview(coinPriceLabel)
        .addArrangedSubview(coinChangeHStack)
        .alignment(.trailing)
        .build()
    
    private lazy var coinChangeHStack = UIStackViewFactory(axis: .horizontal)
        .addArrangedSubview(changeImageView)
        .addArrangedSubview(coinChangeLabel)
        .alignment(.leading)
        .build()
    
    private let logoContainer = UIViewFactory()
        .clipsToBounds(true)
        .cornerRadius(10)
        .build()
    
    private let coinLogo = UIImageViewFactory(image: UIImage(systemName: "questionmark"))
        .tintColor(.black)
        .build()
    
    private let coinLabel = UILabelFactory(text: "Error")
        .fontSize(of: 22, weight: .medium)
        .textColor(with: Theme.accentWhite)
        .build()
    
    private let coinShortName = UILabelFactory(text: "Error")
        .fontSize(of: 16, weight: .semibold)
        .textColor(with: Theme.accentGrey)
        .build()
    
    private let coinPriceLabel = UILabelFactory(text: "Error")
        .fontSize(of: 20, weight: .semibold)
        .textColor(with: Theme.accentWhite)
        .build()
    
    private let coinChangeLabel = UILabelFactory(text: "Error")
        .fontSize(of: 16, weight: .semibold)
        .textColor(with: Theme.accentGrey)
        .build()
    
    private let changeImageView = UIImageViewFactory()
        .build()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = Theme.backgroundColor
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
    
    fileprivate func logoContainerBackgroundSetter(_ coin: Coin) { // adjusting coin backgrounds according to api
        if let coinColorHex = coin.color?.replacingOccurrences(of: "#", with: "") {
            let hexValue = Int(coinColorHex, radix: 16) ?? 0
            let hexColor = UIColor(rgb: hexValue)
            logoContainer.backgroundColor = hexColor.withAlphaComponent(0.2)
            
        } else {
            logoContainer.backgroundColor = .lightGray.withAlphaComponent(0.2)
        }
    }
    
    public func configure(with coin: Coin) {
        
        self.coin = coin
        logoContainerBackgroundSetter(coin)
        
        // MARK: - Coin Name & Short Name
        
        self.coinLabel.text = coin.name
        self.coinShortName.text = coin.symbol
        
        // MARK: - Coin Logos
        
        if var urlString = self.coin.iconURL {
            if urlString.contains("svg") {
                urlString = urlString.replacingOccurrences(of: "svg", with: "png")
            }
            if let url = URL(string: urlString) {
                self.coinLogo.sd_setImage(with: url, placeholderImage: UIImage(systemName: "questionmark"), context: nil)
            }
        }
        
        // MARK: - Coin Prices
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        guard let priceString = coin.price, let price = Double(priceString) else {
            self.coinPriceLabel.text = "$N/A"
            return
        }
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            self.coinPriceLabel.text = formattedPrice
        } else {
            self.coinPriceLabel.text = "$N/A"
        }
        
        // MARK: - Coin change images
        
        if let change = coin.change, let changeDouble = Double(change) {
            let absChange = abs(changeDouble)
            if changeDouble > 0 {
                self.coinChangeLabel.text = "\(absChange)%"
                self.changeImageView.image = UIImage(systemName: "chevron.up")?.withTintColor(.green, renderingMode: .alwaysOriginal)
            } else if changeDouble < 0 {
                self.coinChangeLabel.text = "\(absChange)%"
                self.changeImageView.image = UIImage(systemName: "chevron.down")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            } else {
                self.coinChangeLabel.text = "\(absChange)%"
                self.changeImageView.image = UIImage(systemName: "chevron.up.chevron.down")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                self.changeImageView.image = nil
            }
        } else {
            self.coinChangeLabel.text = "N/A"
            self.coinChangeLabel.textColor = .black
            self.changeImageView.image = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoContainer.layer.cornerRadius = logoContainer.frame.height / 2
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        addSubview(logoContainer)
        logoContainer.addSubview(coinLogo)
        
        NSLayoutConstraint.activate([
            logoContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoContainer.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            logoContainer.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            logoContainer.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            
            coinLogo.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            coinLogo.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            coinLogo.widthAnchor.constraint(equalTo: logoContainer.widthAnchor, multiplier: 0.5),
            coinLogo.heightAnchor.constraint(equalTo: logoContainer.heightAnchor, multiplier: 0.5)
        ])
        
        addSubview(coinLabelVStack)
        
        NSLayoutConstraint.activate([
            coinLabelVStack.leadingAnchor.constraint(equalTo: logoContainer.trailingAnchor, constant: 8),
            coinLabelVStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(coinPriceVStack)
        
        NSLayoutConstraint.activate([
            coinPriceVStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            coinPriceVStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinPriceVStack.leadingAnchor.constraint(equalTo: coinLabelVStack.trailingAnchor, constant: 16)
        ])
    }
    
}

#Preview {
    let navC = UINavigationController(rootViewController: HomeController())
    return navC
}
