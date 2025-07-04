import Foundation
import SwiftUI

class FavoritesManager: ObservableObject {
    @Published var favoriteProducts: [Product] = []
    
    var totalFavorites: Int {
        favoriteProducts.count
    }
    
    func addToFavorites(_ product: Product) {
        if !isFavorite(product) {
            favoriteProducts.append(product)
        }
    }
    
    func removeFromFavorites(_ product: Product) {
        favoriteProducts.removeAll { $0.id == product.id }
    }
    
    func toggleFavorite(_ product: Product) {
        if isFavorite(product) {
            removeFromFavorites(product)
        } else {
            addToFavorites(product)
        }
    }
    
    func isFavorite(_ product: Product) -> Bool {
        favoriteProducts.contains { $0.id == product.id }
    }
    
    func clearFavorites() {
        favoriteProducts.removeAll()
    }
    
    func getFavorites(for gender: Gender? = nil) -> [Product] {
        if let gender = gender {
            return favoriteProducts.filter { $0.gender == gender }
        }
        return favoriteProducts
    }
    
    func getFavorites(for category: ProductCategory? = nil) -> [Product] {
        if let category = category {
            return favoriteProducts.filter { $0.category == category }
        }
        return favoriteProducts
    }
} 