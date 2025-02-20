//
//  MockCurrencyURLProtocol.swift
//  MarshallCryptoTests
//
//  Created by Jont Olof Lyttkens on 2025-02-19.
//

import Foundation
@testable import MarshallCrypto

class MockCurrencyURLProtocol: URLProtocol {
    static var testData: Data?
    static var testResponse: URLResponse?
    static var testError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockCurrencyURLProtocol.testError {
                    client?.urlProtocol(self, didFailWithError: error)
                } else {
                    // Skapa ett giltigt HTTP-svar om inget annat är satt
                    let response = MockCurrencyURLProtocol.testResponse ??
                        HTTPURLResponse(url: request.url!,
                                        statusCode: 200,
                                        httpVersion: nil,
                                        headerFields: nil)!
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                    if let data = MockCurrencyURLProtocol.testData {
                        client?.urlProtocol(self, didLoad: data)
                    }
                    client?.urlProtocolDidFinishLoading(self)
                }
    }
    
    override func stopLoading() {}
    
    func decodeData(data: Data) throws -> CurrencyResponse? {
        return try JSONDecoder().decode(CurrencyResponse.self, from: data)
    }
}

