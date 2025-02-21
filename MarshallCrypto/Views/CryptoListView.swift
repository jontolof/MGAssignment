//
//  ContentView.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-17.
//

import SwiftUI
import SwiftData

// The listing of the Crypto Currencies and the first view to be presented
// to the user. This view has två ViewModels, CryptoModel to manage fetching
// and persistence of the Crypto Data fetched from "https://api.coinlore.net/api/tickers/".
// The currencyModel which handles fetching of exchange rates between SEK and USD,
// provided by "https://marketdata.tradermade.com/api/". See Network folder with CryptoCommunicator
// for more info.
struct CryptoListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var navigationManager = NavigationManager()
    @StateObject var cryptoModel: CryptoListViewModel = .init()
    @StateObject var currencyModel: CurrencyViewModel = .init()
    
    @State var presentingInfo: Bool = false
    @State private var currentDetent: PresentationDetent = .medium
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                Picker("Currency", selection: $currencyModel.selectedCurrency) {
                    Text("SEK").tag(0)
                    Text("USD").tag(1)
                }.pickerStyle(.segmented)
                
                Spacer()
                    .frame(maxHeight: 4.0)
                
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
                    Image("Saint-Guilhelm-Le-Desert")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .shadow(radius: 2.0, x: 1.0, y: 1.0)
                        .opacity(presentingInfo ? 0.1 : 1.0)
                        .onTapGesture {
                            withAnimation {
                                presentingInfo.toggle()
                            }
                        }
                        .animation(.default, value: presentingInfo)
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
            .sheet(isPresented: $presentingInfo) {
                CryptoInfoView(currentDetent: $currentDetent)
                    .presentationDetents([.medium, .large], selection: $currentDetent)
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
