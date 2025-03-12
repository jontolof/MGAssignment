//
//  CryptoItemViewModel.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-19.
//

import Foundation
import SwiftData

// This ViewModel is straight forward. Fetching data, store them in SwiftData.
// In this version the ViewModel is implemented with the @Observable macro,
// instead of the ObservableObject protocol. This mainly reduces the amount of
// boilerplate code required. The method loadData() sets the var items, which
// thanks to the @Observable macro triggers updates of SwiftUI views where applicable.
@MainActor
@Observable
class CryptoListViewModel {
    private let communicator: CryptoCommunicatorAPI
    
    var items: [CryptoItem] = []
    var isLoading: Bool = false
    var error: Error? = nil

    // The init method takes a CryptoCommunicatorAPI-compliant
    // type as injection, defaulting to creating a CryptoCommunicator.
    // This permits dependency-injection and we could easily mock
    // the communicator in tests or switch out the backend completely.
    init(communicator: CryptoCommunicatorAPI = CryptoCommunicator()) {
        self.communicator = communicator
    }
    
    func fetch() {
        error = nil
        
        isLoading = true
        
        Task {
            await fetchData()
            await loadItems()
            isLoading = false
        }
    }
    
    private func fetchData() async {
        let modelContext = SwiftDataManager.shared.backgroundContext
        do {
            let cryptoResponse = try await communicator.getCryptoData()
            for data in cryptoResponse.data {
                let item = CryptoItem(cryptoData: data)
                modelContext.insert(item)
            }
            try modelContext.save()
        }
        catch (let error) {
            print("Error fetching data: \(error)")
        }
    }
    
    func loadItems() async {
        let modelContext = SwiftDataManager.shared.context
        do {
            items = try modelContext.fetch(FetchDescriptor<CryptoItem>()).sorted { $0.marketCapUSD > $1.marketCapUSD }
        } catch (let error) {
            print("Error fetching CryptoItems: \(error)")
        }
    }
    
    func toggleIsLoading() {
        isLoading.toggle()
    }
}
