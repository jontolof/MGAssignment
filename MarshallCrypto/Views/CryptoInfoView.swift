//
//  CryptoInfoView.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-20.
//

import SwiftUI

// An info-view with custom Detent implementation which changes
// layout based on currentDetent. Fullscreen reveals MIT License.
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
                ScrollView(showsIndicators: false) {
                    Text(Constants.mitLicence + "\n\nOS PROJECTS USED: " + Constants.osProjects)
                        .font(.caption)
                }
            }
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: currentDetent)
    }
}
