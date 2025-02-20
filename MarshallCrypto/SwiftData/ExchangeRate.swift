//
//  ExchangeRate.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-20.
//

import Foundation
import SwiftData

@Model
final class ExchangeRate {
    @Attribute(.unique) var exchangeType: String
    @Attribute var rate: Double
    
    init(exchangeType: String, rate: Double) {
        self.exchangeType = exchangeType
        self.rate = rate
    }
    
    convenience init(currencyResponse response: CurrencyResponse) {
        self.init(exchangeType: response.quote.base_currency+response.quote.quote_currency,
                  rate: response.quote.mid)
    }
}
