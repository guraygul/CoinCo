//
//  HomeControllerViewModel.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import UIKit

class HomeControllerViewModel {
    
    // MARK: - Variables
    
    var onCoinsUpdated: (() -> Void)?
    var onFilteredCoinsUpdated: (() -> Void)?
    
    private var allCoins = [Coin]() {
        didSet {
            filterCoins()
        }
    }
    
    private var filteredCoins = [Coin]() {
        didSet {
            self.onCoinsUpdated?()
        }
    }
    
    init() {
        self.fetchCoins()
    }
    
    public func fetchCoins() {
        CoinService.shared.getCoins { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let coinResults):
                self.allCoins = (coinResults.data?.coins)!
                
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Filter Logic
    
    func filterCoins(with searchText: String = "") {
        if searchText.isEmpty {
            filteredCoins = allCoins
        } else {
            filteredCoins = allCoins.filter { coin in
                return coin.name?.lowercased().contains(searchText.lowercased()) ?? false ||
                coin.symbol?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }
    
    func updateSearchResults(for searchText: String) {
        filterCoins(with: searchText)
    }
    
    func coinsCount() -> Int {
        return filteredCoins.count
    }
    
    func resetFilteredCoins() {
        filteredCoins = allCoins
    }
    
    func numberOfFilteredCoins() -> Int {
        return filteredCoins.count
    }
    
    func coin(at index: Int) -> Coin? {
        guard index >= 0 && index < filteredCoins.count else {
            return nil
        }
        return filteredCoins[index]
    }
    
    func sortCoinsBy(option: String) {
        switch option {
        case "Price":
            filteredCoins.sort { coin1, coin2 in
                if let price1 = coin1.price, let price2 = coin2.price {
                    return scientificToDouble(price1) > scientificToDouble(price2)
                }
                return false
            }
        case "Market Cap":
            filteredCoins.sort { coin1, coin2 in
                if let marketCap1 = coin1.marketCap, let marketCap2 = coin2.marketCap {
                    return scientificToDouble(marketCap1) > scientificToDouble(marketCap2)
                }
                return false
            }
        case "24h Volume":
            filteredCoins.sort { coin1, coin2 in
                if let volume1 = coin1.the24HVolume, let volume2 = coin2.the24HVolume {
                    return scientificToDouble(volume1) > scientificToDouble(volume2)
                }
                return false
            }
        case "Change":
            filteredCoins.sort { coin1, coin2 in
                if let change1 = coin1.change, let change2 = coin2.change {
                    return scientificToDouble(change1) > scientificToDouble(change2)
                }
                return false
            }
        case "Listed At":
            filteredCoins.sort { coin1, coin2 in
                if let listedAt1 = coin1.listedAt, let listedAt2 = coin2.listedAt {
                    return listedAt1 > listedAt2
                }
                return false
            }
        default:
            break
        }
    }
    
    private func scientificToDouble(_ scientificNumber: String) -> Double {
        if let doubleValue = Double(scientificNumber) {
            return doubleValue
        }
        return 0.0
    }
    
}

