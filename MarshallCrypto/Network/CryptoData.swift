//
//  CryptoData.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-17.
//

import Foundation

// Create data structures to hold the response from the CryptoAPI
// Currently using "https://www.coinlore.com/cryptocurrency-data-api"

// Worth noting: Normally when using the protocol Codable, you only need to match the
// variable names with that of the API JSON. However, since I want to massage the result
// and decode them into my own types, I need to do a little extra work and I have to
// explicitly decode every parameter, even though only some of them needs that extra
// love. See for example the conversion of String to Double of percent_change_1h et al.
// In the CryptoData struct.

struct CryptoResponse: Codable {
    var data: [CryptoData]
    var info: CryptoInfo
}

struct CryptoInfo: Codable {
    var coins_num: Int
    var time: Date
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coins_num = try container.decode(Int.self, forKey: .coins_num)
        self.time = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .time)) // Decoding timestamp to Date
    }
}

struct CryptoData: Codable {
    var id: Int
    var symbol: String
    var name: String
    var nameid: String
    var rank: Int
    var price_usd: Double
    var percent_change_1h: Double
    var percent_change_24h: Double
    var percent_change_7d: Double
    var price_btc: Double
    var market_cap_usd: Double
    var volume24: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = Int(try container.decode(String.self, forKey: .id))!
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameid = try container.decode(String.self, forKey: .nameid)
        self.rank = try container.decode(Int.self, forKey: .rank)
        self.price_usd = Double(try container.decode(String.self, forKey: .price_usd))!
        self.percent_change_1h = Double(try container.decode(String.self, forKey: .percent_change_1h))!
        self.percent_change_24h = Double(try container.decode(String.self, forKey: .percent_change_24h))!
        self.percent_change_7d = Double(try container.decode(String.self, forKey: .percent_change_7d))!
        self.price_btc = Double(try container.decode(String.self, forKey: .price_btc))!
        self.market_cap_usd = Double(try container.decode(String.self, forKey: .market_cap_usd))!
        self.volume24 = try container.decode(Double.self, forKey: .volume24)
    }
}
