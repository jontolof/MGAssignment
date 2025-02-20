//
//  CurrencyCommunicatorTests.swift
//  MarshallCryptoTests
//
//  Created by Jont Olof Lyttkens on 2025-02-19.
//

import Testing
import Foundation
@testable import MarshallCrypto


// Note: I make a separate MockURLProtocol for Currency to avoid interference
// with the tests run och Crypto
struct CurrencyCommunicatorTests {
    let communicator: CryptoCommunicator

    init() {
        let testBundle = Bundle(for: MockCurrencyURLProtocol.self)
        guard let mockURL = testBundle.url(forResource: "CurrencyAPIResponse", withExtension: "json"),
                let data = try? Data(contentsOf: mockURL) else {
            fatalError("Could not find mock response file")
        }
        
        MockCurrencyURLProtocol.testData = data
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockCurrencyURLProtocol.self]
        let mockSession = URLSession(configuration: config)
        
        communicator = CryptoCommunicator(session: mockSession)
    }
    
    
    @Test func testTimeStamp() async throws {
        let response = try await communicator.getCurrencyData()
        
        #expect(response.time == Date(timeIntervalSince1970: TimeInterval(1739976684)))
    }

}
