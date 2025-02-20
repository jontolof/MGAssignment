//
//  CryptoDetailsView.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-20.
//

import SwiftUI
import SwiftData

struct CryptoDetailsView: View {
    let cryptoId: Int
    @Query private var crypto: [CryptoItem]
    @Query private var exchange: [ExchangeRate]
    let detailsFont: Font = .subheadline
    
    init(cryptoId: Int) {
        self.cryptoId = cryptoId
        
        let predicate = #Predicate<CryptoItem> { $0.id == cryptoId }
        _crypto = Query(filter: predicate)
    }
    
    var body: some View {
            VStack {
                if let symbol = crypto.first?.symbol {
                    CryptoDetailsViewRow { Text("Symbol:").font(detailsFont) } valueView: { Text(symbol).font(detailsFont) }
                }
                
                if let priceUSD = crypto.first?.priceUSD {
                    CryptoDetailsViewRow { Text("Price USD:").font(detailsFont) } valueView: { Text("$ \(priceUSD, specifier: "%.2f")").font(detailsFont) }
                    
                    if let rate = exchange.first?.rate {
                        CryptoDetailsViewRow { Text("Price SEK:").font(detailsFont) } valueView: { Text("\(priceUSD * rate, specifier: "%.2f") kr").font(detailsFont) }
                    }
                }
                
                if let priceBTC = crypto.first?.priceBTC {
                    CryptoDetailsViewRow { Text("Price BTC:").font(detailsFont) } valueView: { Text("\(priceBTC, specifier: "%.8f")").font(detailsFont) }
                }
                
                if let rank = crypto.first?.rank {
                    CryptoDetailsViewRow { Text("Rank:").font(detailsFont) } valueView: { Text("\(rank)").font(detailsFont) }
                }
                
                if let marketCapUSD = crypto.first?.marketCapUSD {
                    CryptoDetailsViewRow { Text("Market Cap USD:").font(detailsFont) } valueView: { Text("$ \(marketCapUSD, specifier: "%.2f")").font(detailsFont) }
                }
                
                if let volumeUSD24Hr = crypto.first?.volume24 {
                    CryptoDetailsViewRow { Text("Volume USD 24hr:").font(detailsFont) } valueView: { Text("$ \(volumeUSD24Hr, specifier: "%.2f")").font(detailsFont) }
                }
                
                if let percentChange1h = crypto.first?.percentChange1h {
                    CryptoDetailsViewRow { Text("1h Percent Change:").font(detailsFont) } valueView: {
                        if percentChange1h != 0.0 {
                            Image(systemName: percentChange1h > 0.0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(percentChange1h > 0 ? Color.green : Color.red)
                        }
                            
                        Text("\(percentChange1h, specifier: "%.2f")%").font(detailsFont)
                    }
                }
                
                if let percentChange24h = crypto.first?.percentChange24h {
                    CryptoDetailsViewRow { Text("24h Percent Change:").font(detailsFont) } valueView: {
                        if percentChange24h != 0.0 {
                            Image(systemName: percentChange24h > 0.0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(percentChange24h > 0 ? Color.green : Color.red)
                        }
                        
                        Text("\(percentChange24h, specifier: "%.2f")%").font(detailsFont)
                    }
                }
                
                if let percentChange7d = crypto.first?.percentChange7d {
                    CryptoDetailsViewRow { Text("7d Percent Change:").font(detailsFont) } valueView: {
                        if percentChange7d != 0.0 {
                            Image(systemName: percentChange7d > 0.0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(percentChange7d > 0 ? Color.green : Color.red)
                        }
                        
                        Text("\(percentChange7d, specifier: "%.2f")%").font(detailsFont)
                    }
                }
                
                Spacer()
                    .frame(height: 60.0)
                
                if let item = crypto.first {
                    let imageName = item.symbol.lowercased() == "add" ? "addcrp" : item.symbol.lowercased()
                    Image(imageName)
                        .resizable()
                        .frame(width:128, height: 128.0)
                }
                
                Spacer()
            }
            .navigationTitle(crypto.first?.name ?? "")
    }
}

struct CryptoDetailsViewRow<TitleContent: View, ValueContent: View>: View {
    @ViewBuilder let titleView: TitleContent
    @ViewBuilder let valueView: ValueContent
    
    var body: some View {
        HStack {
            titleView
            Spacer()
            valueView
        }
        .padding([.leading, .trailing])
        .padding([.bottom, .top], 4.0)
    }
}


#Preview {
    CryptoDetailsView(cryptoId: 0)
}
