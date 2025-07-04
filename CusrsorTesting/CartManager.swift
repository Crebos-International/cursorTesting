import Foundation
import SwiftUI

class CartManager: ObservableObject {
    @Published var cartItems: [CartItem] = []
    
    var totalItems: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var subtotal: Double {
        cartItems.reduce(0) { $0 + ($1.product.isOnSale ? ($1.product.salePrice ?? $1.product.price) : $1.product.price) * Double($1.quantity) }
    }
    
    var tax: Double {
        subtotal * 0.08 // 8% tax
    }
    
    var total: Double {
        subtotal + tax
    }
    
    func addToCart(_ product: Product) {
        if let existingIndex = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[existingIndex].quantity += 1
        } else {
            cartItems.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func removeFromCart(_ product: Product) {
        cartItems.removeAll { $0.product.id == product.id }
    }
    
    func updateQuantity(for product: Product, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            if quantity <= 0 {
                cartItems.remove(at: index)
            } else {
                cartItems[index].quantity = quantity
            }
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
    func getQuantity(for product: Product) -> Int {
        return cartItems.first { $0.product.id == product.id }?.quantity ?? 0
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
} 