//
//  MockURLProtocol.swift
//  MarshallCryptoTests
//
//  Created by Jont Olof Lyttkens on 2025-02-18.
//

import Foundation
@testable import MarshallCrypto


// MockURLProtocol is used to create a predictable input data for testing. In
// this way we can verify the outputData of the Communicator based on a controlled
// input environment. It's essential to let startLoading() call all the client's callbacks
// from error (if applicable) to response and data. Even though in this limited test suite,
// we only really care about 'data'. If not you will see some funky test behavior,
// without any helpful error or exceptions to debug.
class MockCryptoURLProtocol: URLProtocol {
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
        if let error = MockCryptoURLProtocol.testError {
                    client?.urlProtocol(self, didFailWithError: error)
                } else {
                    // Skapa ett giltigt HTTP-svar om inget annat är satt
                    let response = MockCryptoURLProtocol.testResponse ??
                        HTTPURLResponse(url: request.url!,
                                        statusCode: 200,
                                        httpVersion: nil,
                                        headerFields: nil)!
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                    if let data = MockCryptoURLProtocol.testData {
                        client?.urlProtocol(self, didLoad: data)
                    }
                    client?.urlProtocolDidFinishLoading(self)
                }
    }
    
    override func stopLoading() {}
    
    func decodeData(data: Data) throws -> CryptoResponse? {
        return try JSONDecoder().decode(CryptoResponse.self, from: data)
    }
}

