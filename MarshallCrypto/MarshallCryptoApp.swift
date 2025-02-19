//
//  MarshallCryptoApp.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-17.
//

import SwiftUI
import SwiftData

@main
struct MarshallCryptoApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(SwiftDataManager.shared.sharedModelContainer)
    }
}
