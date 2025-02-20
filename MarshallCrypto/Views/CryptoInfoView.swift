//
//  CryptoInfoView.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-20.
//

import SwiftUI

struct CryptoInfoView: View {
    @Binding var currentDetent: PresentationDetent
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 60)
            Text("Marshall Crypto")
                .font(.largeTitle)
            Text("By Jont Olof Lyttkens")
                .font(.caption)
            
            Image("Saint-Guilhelm-Le-Desert")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            
            Spacer()
                .frame(height: 40)
            
            if currentDetent == .large {
                ScrollView {
                    Text(Constants.mitLicence)
                        .font(.caption)
                }
            }
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: currentDetent)
    }
}
