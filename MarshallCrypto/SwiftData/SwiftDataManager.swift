//
//  SwiftDataManager.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-18.
//

import Foundation
import SwiftData

class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CryptoItem.self,
            ExchangeRate.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @MainActor var context: ModelContext {
        sharedModelContainer.mainContext
    }
    
    var backgroundContext: ModelContext {
        ModelContext(sharedModelContainer)
    }
}
