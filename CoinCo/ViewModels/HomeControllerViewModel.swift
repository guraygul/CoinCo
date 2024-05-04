//
//  HomeControllerViewModel.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import Foundation

class HomeControllerViewModel {

    var onCoinsUpdated: (() -> Void)?
    
    private(set) var coins = [Coin]() {
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
                self.coins = (coinResults.data?.coins)!
                
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
}
