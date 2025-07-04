//
//  CusrsorTestingApp.swift
//  CusrsorTesting
//
//  Created by Himank Bansal on 02/07/25.
//

import SwiftUI

@main
struct CusrsorTestingApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var cartManager = CartManager()
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(cartManager)
                .environmentObject(favoritesManager)
        }
    }
}
