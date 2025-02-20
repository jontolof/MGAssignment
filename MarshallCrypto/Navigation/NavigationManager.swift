//
//  NavigationManager.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-20.
//

import SwiftUI

// A nifty enum based NavigationStack system.
// Great because it is a scalable and easy way to handle
// Navigation Routing where data injection is required, and
// the resulting code is clean and clear.
enum Router: Hashable {
    case home
    case cryptoDetails(itemId: Int)
}

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to router: Router) {
        path.append(router)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func reset() {
        path = NavigationPath()
    }
}


