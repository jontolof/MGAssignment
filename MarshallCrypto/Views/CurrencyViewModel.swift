//
//  CurrencyViewModel.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-19.
//

import Foundation
import SwiftData

@MainActor
class CurrencyViewModel: ObservableObject {
    @Published var exchangeRate: ExchangeRate? = nil
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    @Published var currencyMultiplier: Double = 1.0
    @Published var selectedCurrency: Int = 1 {
        didSet {
            currencyMultiplier = selectedCurrency == 0 ? exchangeRate?.rate ?? 1.0 : 1.0
        }
    }
    
    func fetch() {
        error = nil
        isLoading = true
        
        Task {
            await fetchData()
            await loadExchangeRate()
            isLoading = false
        }
    }
    
    private func fetchData() async {
        let modelContext = SwiftDataManager.shared.backgroundContext

        do {
            let currencyResponse = try await CryptoCommunicator.shared.getCurrencyData()
            let item = ExchangeRate(currencyResponse: currencyResponse)
            modelContext.insert(item)
            try modelContext.save()
        }
        catch (let error) {
            print("Error fetching data: \(error)")
        }
    }
    
    @MainActor func loadExchangeRate() async {
        let modelContext = SwiftDataManager.shared.context
        do {
            let allRates = try modelContext.fetch(FetchDescriptor<ExchangeRate>())
            exchangeRate = allRates.first
        } catch (let error) {
            print("Error fetching CryptoItems: \(error)")
        }
    }
}
