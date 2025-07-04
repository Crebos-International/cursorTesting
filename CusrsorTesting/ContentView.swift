//
//  ContentView.swift
//  CusrsorTesting
//
//  Created by Himank Bansal on 02/07/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                HomeView()
            } else {
                AuthView()
            }
        }
        .animation(.easeInOut, value: authManager.isAuthenticated)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
        .environmentObject(CartManager())
        .environmentObject(FavoritesManager())
}
