//
//  CoinModel.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import Foundation

// MARK: - Welcome
struct CoinModel: Codable {
    let status: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let stats: Stats?
    let coins: [Coin]?
}

// MARK: - Coin
struct Coin: Codable {
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
struct Stats: Codable {
    let total, totalCoins, totalMarkets, totalExchanges: Int?
    let totalMarketCap, total24HVolume: String?

    enum CodingKeys: String, CodingKey {
        case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap
        case total24HVolume = "total24hVolume"
    }
}

extension CoinModel {
    public func getMockCoinArray() -> [Coin] {
        return [
            Coin(uuid: "Qwsogvtv82FCd", symbol: "BTC", name: "Bitcoin", color: "f7931A", iconURL: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg", marketCap: "1064845170034", price: "56373.67522635439", listedAt: 1330214400, tier: 1, change: "-3.61", rank: 1, sparkline: [""], lowVolume: false, coinrankingURL: "https://coinranking.com/coin/Qwsogvtv82FCd+bitcoin-btc", the24HVolume: "39591261551", btcPrice: "1")
        ]
    }
}
