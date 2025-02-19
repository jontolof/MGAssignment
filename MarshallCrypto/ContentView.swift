//
//  ContentView.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-17.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel: CryptoItemViewModel = .init()
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.fetch()
            }) {
                Text("Fetch")
            }
            
            Spacer()
                .frame(maxHeight: 40.0)
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack {
                        ForEach(viewModel.items) { item in
                            let _ = print("Item.name: \(item.name)")
                            Text("Name: \(item.name)")
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadItems()
            }
        }
    }
}

@MainActor
class CryptoItemViewModel: ObservableObject {
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


#Preview {
    ContentView()
        .modelContainer(for: CryptoItem.self, inMemory: true)
}
