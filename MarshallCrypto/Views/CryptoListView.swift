//
//  ContentView.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-17.
//

import SwiftUI
import SwiftData

struct CryptoListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var navigationManager = NavigationManager()
    @StateObject var cryptoModel: CryptoListViewModel = .init()
    @StateObject var currencyModel: CurrencyViewModel = .init()
    
    @State var presentingInfo: Bool = false
    
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                Picker("Currency", selection: $currencyModel.selectedCurrency) {
                    Text("SEK").tag(0)
                    Text("USD").tag(1)
                }.pickerStyle(.segmented)
                
                if currencyModel.isLoading {
                    Text("Loading...")
                } else if currencyModel.exchangeRate != nil {
                    Text("SEK/USD: \(currencyModel.exchangeRate!.rate, specifier: "%.2f")")
                } else {
                    EmptyView()
                }
                
                Spacer()
                    .frame(maxHeight: 20.0)
                
                if cryptoModel.items.isEmpty {
                    Button(action: {
                        cryptoModel.fetch()
                        currencyModel.fetch()
                    }) {
                        Text("Fetch")
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 1.0) {
                            ForEach(cryptoModel.items, id: \.self) { item in
                                CryptoRow.init(item: item, currencyModel: currencyModel)
                                    .onTapGesture {
                                        navigationManager.navigate(to: .cryptoDetails(itemId: item.id))
                                    }
                            }
                        }
                    }
                    .refreshable {
                        Task {
                            cryptoModel.fetch()
                            currencyModel.fetch()
                        }
                    }
                }
            }
            .navigationTitle(Text("Crypto"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentingInfo.toggle()
                    } label: {
                        Text("Info")
                    }
                }
            }
            .navigationDestination(for: Router.self) { router in
                switch router {
                case .home:
                    CryptoListView()
                case .cryptoDetails(let itemId):
                    CryptoDetailsView(cryptoId: itemId)
                @unknown default:
                    fatalError()
                }
            }
        }
        .onAppear {
            Task {
                await currencyModel.loadExchangeRate()
                await cryptoModel.loadItems()
            }
        }
    }
}

struct CryptoRow: View {
    var item: CryptoItem
    @ObservedObject var currencyModel: CurrencyViewModel
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    let imageName = item.symbol.lowercased() == "add" ? "addcrp" : item.symbol.lowercased()
                    let image = UIImage(named: imageName) ?? UIImage(named: "ctr")!
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 32, height: 32)
                    Text("\(item.name) (\(item.symbol))")
                }
                
                Spacer()
                
                Text("\(item.priceUSD * currencyModel.currencyMultiplier, specifier: "%.2f")")
            }
            .padding()
        }
        .background(Color.gray.opacity(0.05))
        .frame(maxWidth: .infinity)
    }
}



#Preview {
    CryptoListView()
        .modelContainer(for: CryptoItem.self, inMemory: true)
}
