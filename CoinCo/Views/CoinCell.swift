//
//  CoinCell.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import UIKit
import SDWebImage

class CoinCell: UITableViewCell {
    
    static let identifier = "CoinCell"
    
    // MARK: - Variables
    
    private var coin: Coin!
    
    // MARK: - UI Components
    
    private let logoContainer: UIView = {
        let lc = UIView()
        lc.clipsToBounds = true
        return lc
    }()
    
    private let coinLogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .black
        return iv
    }()
      
    private let coinLabel = UILabelFactory(text: "Error")
        .fontSize(of: 22)
        .textColor(with: Theme.accentWhite)
        .build()
        
    private let coinShortName = UILabelFactory(text: "Error")
        .fontSize(of: 16)
        .textColor(with: Theme.accentGrey)
        .build()
    
    private let coinPriceLabel = UILabelFactory(text: "Error")
        .fontSize(of: 20)
        .textColor(with: Theme.accentWhite)
        .build()
    
    private let coinChangeLabel = UILabelFactory(text: "Error")
        .fontSize(of: 16)
        .textColor(with: Theme.accentGrey)
        .build()
    
    private let changeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
            logoContainer.backgroundColor = hexColor.withAlphaComponent(0.5)
            
        } else { // If no color was provided for coin
            logoContainer.backgroundColor = .black.withAlphaComponent(0.5)
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
        self.addSubview(coinLabel)
        self.addSubview(coinShortName)
        self.addSubview(coinPriceLabel)
        self.addSubview(coinChangeLabel)
        self.addSubview(changeImageView)
        self.addSubview(logoContainer)
        
        self.logoContainer.addSubview(coinLogo)
        
        coinLogo.translatesAutoresizingMaskIntoConstraints = false
        changeImageView.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoContainer.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            logoContainer.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            logoContainer.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            
            coinLogo.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            coinLogo.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            coinLogo.widthAnchor.constraint(equalTo: logoContainer.widthAnchor, multiplier: 0.5),
            coinLogo.heightAnchor.constraint(equalTo: logoContainer.heightAnchor, multiplier: 0.5),
            
            coinLabel.leadingAnchor.constraint(equalTo: logoContainer.trailingAnchor, constant: 8),
            coinLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 4),
            coinLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: 92),
            
            coinShortName.leadingAnchor.constraint(equalTo: logoContainer.trailingAnchor, constant: 8),
            coinShortName.topAnchor.constraint(equalTo: self.coinLabel.bottomAnchor, constant: 4),
            
            coinPriceLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            coinPriceLabel.centerYAnchor.constraint(equalTo: coinLabel.centerYAnchor),
            
            coinChangeLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            coinChangeLabel.centerYAnchor.constraint(equalTo: coinShortName.centerYAnchor),
            
            changeImageView.centerYAnchor.constraint(equalTo: coinChangeLabel.centerYAnchor),
            changeImageView.trailingAnchor.constraint(equalTo: coinChangeLabel.leadingAnchor, constant: -4),
            changeImageView.widthAnchor.constraint(equalToConstant: 20),
            changeImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

#Preview {
    let navC = UINavigationController(rootViewController: HomeController())
    return navC
}
