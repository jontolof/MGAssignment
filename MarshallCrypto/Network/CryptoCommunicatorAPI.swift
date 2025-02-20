//
//  CryptoCommunicator.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-17.
//

import Foundation


// We build a CryptoCommunicatorAPI Protocol for our communicator to comply to.
// This is a good practice as we can easily switch out our backend communications
// layer and it facilitates testing.
protocol CryptoCommunicatorAPI {
    func getCryptoData() async throws -> CryptoResponse
    func getCurrencyData() async throws -> CurrencyResponse
}
