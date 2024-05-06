//
//  DetailControllerViewModel.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import Foundation
import SDWebImage

class DetailControllerViewModel {
    
    // MARK: - Variables
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
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
    
    var coinChangeLabel: String {
        return "Change: \(String(describing: self.coin.change))"
    }
}
