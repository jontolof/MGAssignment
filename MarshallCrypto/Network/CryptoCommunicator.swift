//
//  CryptoCommunicator.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-17.
//

import Foundation

private let apiURL = "https://api.coinlore.net/api/tickers/"
private let traderMadeAPIKey = "ANO60xYlKF7e1iGOjIxy"

class CryptoCommunicator: CryptoCommunicatorAPI {
    static let shared = CryptoCommunicator()
    
    let session: URLSession
    
    // Inject the URLSession to make class testable
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Comply to API
    // The return type of the Generic fetchData is implied by the return
    // type of getCryptoData
    func getCryptoData() async throws -> CryptoResponse {
        return try await fetchData(url: URL(string: apiURL)!)
    }
    
    func getCurrencyData() async throws -> CurrencyResponse {
        let url = URL(string: "https://marketdata.tradermade.com/api/v1/live?currency=USDSEK&api_key=" + traderMadeAPIKey)!
        return try await fetchData(url: url)
    }
    
    // We create a Generic fetchData to minimize code and risk of error as we expand
    // the number of API calls.
    func fetchData<T: Decodable>(url: URL, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        do {
            let (data, _) = try await session.data(from: url)
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Failed to fetch data: \(error)")
            throw error
        }
    }
    
}
