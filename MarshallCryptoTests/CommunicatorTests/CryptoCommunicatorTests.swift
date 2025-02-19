//
//  MarshallCryptoTests.swift
//  MarshallCryptoTests
//
//  Created by Jont Olof Lyttkens on 2025-02-17.
//

import Testing
import Foundation
@testable import MarshallCrypto

// This suite of tests will ensure that the communicator delivers a correct
// CryptoResponse from mocked data with an identical structure to the
// API in use.

struct CryptoCommunicatorTests {
    let communicator: CryptoCommunicator
    
    // We use the init function to setup the prerequisites for the all the
    // tests. In XCTest we would do this in setup() or setupWithErrors()
    init() {
        let testBundle = Bundle(for: MockURLProtocol.self)
        guard let mockURL = testBundle.url(forResource: "APIResponse", withExtension: "json"),
                let data = try? Data(contentsOf: mockURL) else {
            fatalError("Could not find mock response file")
        }
        
        MockURLProtocol.testData = data
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)
        
        communicator = CryptoCommunicator(session: mockSession)
    }
    
    @Test func testNumCoinsIsThree() async throws {
        let response = try await communicator.getCryptoData()
        
        // #expect is the Swift Testing equivalent of
        // XCTAssert.
        #expect(response.info.coins_num == 3)
    }
    
    @Test func testResponseDate() async throws {
        let testTimeStamp = 1739833808
        let testDate = Date(timeIntervalSince1970: TimeInterval(testTimeStamp))
        
        let response = try await communicator.getCryptoData()
        
        #expect(response.info.time == testDate)
    }
    
    @Test func testResponseFirstCoinName() async throws {
        let response = try await communicator.getCryptoData()
        
        #expect(response.data[0].name == "Bitcoin")
    }
    
    @Test func testResponseFirstCoin1hPercentChange() async throws {
        let response = try await communicator.getCryptoData()
        
        #expect(response.data[0].percent_change_1h == -0.31)
    }
}

