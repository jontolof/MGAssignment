//
//  CurrencyData.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-19.
//

import Foundation


// This follows the same strategy as the CryptoData. I am using my custom
// CodingKeyes to decode timestamp to time. This requires me to implement the encode()
// function as well.
struct CurrencyResponse: Codable {
    enum CodingKeys: CodingKey {
        case quotes
        case timestamp
    }
    
    let quote: CurrencyQuote
    let time: Date
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.quote = (try container.decode([CurrencyQuote].self, forKey: .quotes)).first!
        self.time = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .timestamp))
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode([quote], forKey: .quotes)
        try container.encode(time.timeIntervalSince1970, forKey: .timestamp)
    }
}

struct CurrencyQuote: Codable {
    let ask: Double
    let base_currency: String
    let bid: Double
    let mid: Double
    let quote_currency: String
}
