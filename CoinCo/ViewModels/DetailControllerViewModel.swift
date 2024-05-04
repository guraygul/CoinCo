//
//  DetailControllerViewModel.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import Foundation
import SDWebImage
import SDWebImageSVGNativeCoder

class DetailControllerViewModel {
    
    var onImageLoaded: ((UIImage?) -> Void)?
    
    // MARK: - Variables
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        self.loadImage()
    }
    
    private func loadImage() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            if let urlString = self.coin.iconURL, let url = URL(string: urlString) {
                SDWebImageManager.shared.loadImage(with: url, options: [], context: nil, progress: nil) { [weak self] (image, _, _, _, _, _) in
                    guard let self = self else { return }
                    self.onImageLoaded?(image)
                }
            } else {
                self.onImageLoaded?(UIImage(systemName: "questionmark"))
            }
        }
    }
    
    // MARK: - Computed Properties
    var rankLabel: String {
        return "Rank: \(String(describing: self.coin.rank))"
    }
    
    var priceLabel: String {
        return "Price: $\(String(describing: self.coin.price)) USD"
    }
    
    var marketCapLabel: String {
        return "Market Cap: \(String(describing: self.coin.marketCap)) USD"
    }
    
    var maxSupplyLabel: String {
        return "Max Supply: \(String(describing: self.coin.the24HVolume))"
    }
}
