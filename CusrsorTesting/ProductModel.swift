import Foundation

struct Product: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageName: String
    let category: ProductCategory
    let gender: Gender
    let rating: Double
    let isOnSale: Bool
    let salePrice: Double?
    
    var displayPrice: String {
        if isOnSale, let salePrice = salePrice {
            return "$\(String(format: "%.2f", salePrice))"
        }
        return "$\(String(format: "%.2f", price))"
    }
    
    var originalPrice: String? {
        if isOnSale {
            return "$\(String(format: "%.2f", price))"
        }
        return nil
    }
}

enum ProductCategory: String, CaseIterable, Codable {
    case clothing = "Clothing"
    case shoes = "Shoes"
    case accessories = "Accessories"
    case bags = "Bags"
    case jewelry = "Jewelry"
}

enum Gender: String, CaseIterable, Codable {
    case men = "Men"
    case women = "Women"
    case unisex = "Unisex"
}

// Sample product data
extension Product {
    static let sampleProducts: [Product] = [
        // Men's Products
        Product(id: "1", name: "Classic White T-Shirt", description: "Premium cotton crew neck t-shirt", price: 29.99, imageName: "tshirt", category: .clothing, gender: .men, rating: 4.5, isOnSale: false, salePrice: nil),
        Product(id: "2", name: "Slim Fit Jeans", description: "Dark wash slim fit denim jeans", price: 79.99, imageName: "jeans", category: .clothing, gender: .men, rating: 4.3, isOnSale: true, salePrice: 59.99),
        Product(id: "3", name: "Leather Sneakers", description: "Casual leather sneakers with rubber sole", price: 89.99, imageName: "sneakers", category: .shoes, gender: .men, rating: 4.7, isOnSale: false, salePrice: nil),
        Product(id: "4", name: "Leather Wallet", description: "Genuine leather bifold wallet", price: 49.99, imageName: "wallet", category: .accessories, gender: .men, rating: 4.2, isOnSale: false, salePrice: nil),
        Product(id: "5", name: "Denim Jacket", description: "Classic denim jacket with brass buttons", price: 119.99, imageName: "jacket", category: .clothing, gender: .men, rating: 4.6, isOnSale: true, salePrice: 89.99),
        Product(id: "6", name: "Running Shoes", description: "Lightweight running shoes with cushioning", price: 129.99, imageName: "runningshoes", category: .shoes, gender: .men, rating: 4.8, isOnSale: false, salePrice: nil),
        
        // Women's Products
        Product(id: "7", name: "Floral Dress", description: "Elegant floral print summer dress", price: 89.99, imageName: "dress", category: .clothing, gender: .women, rating: 4.6, isOnSale: false, salePrice: nil),
        Product(id: "8", name: "High Heel Pumps", description: "Classic black high heel pumps", price: 99.99, imageName: "heels", category: .shoes, gender: .women, rating: 4.4, isOnSale: true, salePrice: 79.99),
        Product(id: "9", name: "Leather Handbag", description: "Stylish leather crossbody handbag", price: 149.99, imageName: "handbag", category: .bags, gender: .women, rating: 4.7, isOnSale: false, salePrice: nil),
        Product(id: "10", name: "Silver Necklace", description: "Delicate silver chain necklace", price: 69.99, imageName: "necklace", category: .jewelry, gender: .women, rating: 4.3, isOnSale: false, salePrice: nil),
        Product(id: "11", name: "Skinny Jeans", description: "High-waisted skinny jeans in blue", price: 89.99, imageName: "womensjeans", category: .clothing, gender: .women, rating: 4.5, isOnSale: true, salePrice: 69.99),
        Product(id: "12", name: "Ankle Boots", description: "Chic ankle boots with block heel", price: 119.99, imageName: "boots", category: .shoes, gender: .women, rating: 4.6, isOnSale: false, salePrice: nil),
    ]
    
    static func products(for gender: Gender) -> [Product] {
        return sampleProducts.filter { $0.gender == gender }
    }
    
    static func products(for category: ProductCategory, gender: Gender) -> [Product] {
        return sampleProducts.filter { $0.category == category && $0.gender == gender }
    }
} 