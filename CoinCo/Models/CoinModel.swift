//
//  CoinModel.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import Foundation

// MARK: - CoinModel
struct CoinModel: Decodable {
    let status: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Decodable {
    let stats: Stats?
    let coins: [Coin]?
}

// MARK: - Coin
struct Coin: Decodable {
    let uuid, symbol, name, color: String?
    let iconURL: String?
    let marketCap, price: String?
    let listedAt, tier: Int?
    let change: String?
    let rank: Int?
    let sparkline: [String]?
    let lowVolume: Bool?
    let coinrankingURL: String?
    let the24HVolume, btcPrice: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color
        case iconURL = "iconUrl"
        case marketCap, price, listedAt, tier, change, rank, sparkline, lowVolume
        case coinrankingURL = "coinrankingUrl"
        case the24HVolume = "24hVolume"
        case btcPrice
    }
}

// MARK: - Stats
struct Stats: Decodable {
    let total, totalCoins, totalMarkets, totalExchanges: Int?
    let totalMarketCap, total24HVolume: String?
    
    enum CodingKeys: String, CodingKey {
        case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap
        case total24HVolume = "total24hVolume"
    }
}
