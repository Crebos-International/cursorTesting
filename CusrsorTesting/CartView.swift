import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingCheckout = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if cartManager.cartItems.isEmpty {
                    // Empty cart state
                    VStack(spacing: 20) {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("Your cart is empty")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        
                        Text("Add some products to get started")
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Text("Continue Shopping")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.05))
                } else {
                    // Cart items list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(cartManager.cartItems) { item in
                                CartItemRow(item: item, cartManager: cartManager)
                            }
                        }
                        .padding()
                    }
                    
                    // Checkout section
                    VStack(spacing: 16) {
                        Divider()
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Subtotal")
                                Spacer()
                                Text("$\(String(format: "%.2f", cartManager.subtotal))")
                            }
                            
                            HStack {
                                Text("Tax (8%)")
                                Spacer()
                                Text("$\(String(format: "%.2f", cartManager.tax))")
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("$\(String(format: "%.2f", cartManager.total))")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.horizontal)
                        
                        Button(action: { showingCheckout = true }) {
                            Text("Proceed to Checkout")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .background(Color.white)
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !cartManager.cartItems.isEmpty {
                        Button("Clear") {
                            cartManager.clearCart()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $showingCheckout) {
                CheckoutView()
            }
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    let cartManager: CartManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Product image
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: getProductIcon(for: item.product))
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                )
            
            // Product details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(item.product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text(item.product.displayPrice)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    if let originalPrice = item.product.originalPrice {
                        Text(originalPrice)
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            // Quantity controls
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Button(action: {
                        cartManager.updateQuantity(for: item.product, quantity: item.quantity - 1)
                    }) {
                        Image(systemName: "minus")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    
                    Text("\(item.quantity)")
                        .font(.headline)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        cartManager.updateQuantity(for: item.product, quantity: item.quantity + 1)
                    }) {
                        Image(systemName: "plus")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                
                Button(action: {
                    cartManager.removeFromCart(item.product)
                }) {
                    Text("Remove")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func getProductIcon(for product: Product) -> String {
        switch product.category {
        case .clothing:
            return "tshirt"
        case .shoes:
            return "shoe"
        case .accessories:
            return "watch"
        case .bags:
            return "bag"
        case .jewelry:
            return "diamond"
        }
    }
}

struct CheckoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Order Placed Successfully!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Thank you for your purchase. You will receive an email confirmation shortly.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                VStack(spacing: 8) {
                    Text("Order Total: $\(String(format: "%.2f", cartManager.total))")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Items: \(cartManager.totalItems)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    cartManager.clearCart()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Continue Shopping")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding()
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    CartView()
        .environmentObject(CartManager())
} 