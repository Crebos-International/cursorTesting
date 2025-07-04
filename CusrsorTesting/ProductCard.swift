import SwiftUI

struct ProductCard: View {
    let product: Product
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Product Image
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 180)
                    .overlay(
                        Image(systemName: getProductIcon())
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                    )
                
                // Favorite button
                Button(action: { favoritesManager.toggleFavorite(product) }) {
                    Image(systemName: favoritesManager.isFavorite(product) ? "heart.fill" : "heart")
                        .foregroundColor(favoritesManager.isFavorite(product) ? .red : .gray)
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(8)
                
                // Sale badge
                if product.isOnSale {
                    VStack {
                        Text("SALE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                // Product name
                Text(product.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                // Product description
                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Rating
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    Text("(\(String(format: "%.1f", product.rating)))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Price
                HStack {
                    Text(product.displayPrice)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    if let originalPrice = product.originalPrice {
                        Text(originalPrice)
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Add to cart button
                    Button(action: {
                        cartManager.addToCart(product)
                    }) {
                        Image(systemName: "plus")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
    
    private func getProductIcon() -> String {
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

#Preview {
    ProductCard(product: Product.sampleProducts[0])
        .frame(width: 180)
        .padding()
        .environmentObject(CartManager())
        .environmentObject(FavoritesManager())
} 