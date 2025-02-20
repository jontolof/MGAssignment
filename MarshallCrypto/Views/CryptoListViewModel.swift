//
//  CryptoItemViewModel.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-19.
//

import Foundation
import SwiftData

// This ViewModel is straight forward. Fetching data, store them in SwiftData.
// The method loadData() sets the @Published var items, which triggers updates
// of SwiftUI views where applicable.

@MainActor
class CryptoListViewModel: ObservableObject {
    @Published var items: [CryptoItem] = []
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
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
            let cryptoResponse = try await CryptoCommunicator.shared.getCryptoData()
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
    
    @MainActor func loadItems() async {
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
