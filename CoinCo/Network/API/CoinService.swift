//
//  CoinService.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import Foundation

final class CoinService {
    
    static let shared: CoinService = {
        let instance = CoinService()
        return instance
    }()
    
    private init() {}
    
    func getCoins(completionHandler: @escaping (Result<CoinModel, any Error>) -> Void) {
        NetworkManager.shared.request(request: URLRequest(url: URL(string: Constants.fullURL)!), decodeType: CoinModel.self, completionHandler: completionHandler)
    }
}
