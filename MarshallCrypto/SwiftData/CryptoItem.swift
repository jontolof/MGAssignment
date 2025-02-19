//
//  CryptoItem.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-17.
//

import Foundation
import SwiftData

@Model
final class CryptoItem {
    @Attribute(.unique) var id: Int
    var symbol: String
    var name: String
    var nameId: String
    var rank: Int
    var priceUSD: Double
    var percentChange1h: Double
    var percentChange24h: Double
    var percentChange7d: Double
    var priceBTC: Double
    var marketCapUSD: Double
    var volume24: Double
    
    init(id: Int, symbol: String, name: String, nameId: String, rank: Int, priceUSD: Double, percentChange1h: Double, percentChange24h: Double, percentChange7d: Double, priceBTC: Double, marketCapUSD: Double, volume24: Double) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.nameId = nameId
        self.rank = rank
        self.priceUSD = priceUSD
        self.percentChange1h = percentChange1h
        self.percentChange24h = percentChange24h
        self.percentChange7d = percentChange7d
        self.priceBTC = priceBTC
        self.marketCapUSD = marketCapUSD
        self.volume24 = volume24
    }
    
    convenience init(cryptoData data: CryptoData) {
        self.init(id: data.id,
                  symbol: data.symbol,
                  name: data.name,
                  nameId: data.nameid,
                  rank: data.rank,
                  priceUSD: data.price_usd,
                  percentChange1h: data.percent_change_1h,
                  percentChange24h: data.percent_change_24h,
                  percentChange7d: data.percent_change_7d,
                  priceBTC: data.price_btc,
                  marketCapUSD: data.market_cap_usd,
                  volume24: data.volume24)

    }
}
