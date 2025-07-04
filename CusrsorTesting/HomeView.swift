import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var selectedGender: Gender = .men
    @State private var selectedCategory: ProductCategory? = nil
    @State private var searchText = ""
    @State private var showingProfile = false
    @State private var showingCart = false
    @State private var showingFavorites = false
    
    var filteredProducts: [Product] {
        var products = Product.products(for: selectedGender)
        
        if let category = selectedCategory {
            products = products.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            products = products.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return products
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 15) {
                    // Top bar with profile and search
                    HStack {
                        Button(action: { showingProfile = true }) {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Text("StyleStore")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Button(action: { showingFavorites = true }) {
                                ZStack {
                                    Image(systemName: "heart")
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                    
                                    if favoritesManager.totalFavorites > 0 {
                                        Text("\(favoritesManager.totalFavorites)")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(4)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                            .offset(x: 10, y: -10)
                                    }
                                }
                            }
                            
                            Button(action: { showingCart = true }) {
                                ZStack {
                                    Image(systemName: "cart")
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                    
                                    if cartManager.totalItems > 0 {
                                        Text("\(cartManager.totalItems)")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(4)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                            .offset(x: 10, y: -10)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search products...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.top)
                .background(Color.white)
                
                // Gender selector
                Picker("Gender", selection: $selectedGender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue).tag(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)
                
                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryChip(title: "All", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        
                        ForEach(ProductCategory.allCases, id: \.self) { category in
                            CategoryChip(
                                title: category.rawValue,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                .background(Color.white)
                
                // Products collection
                if filteredProducts.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No products found")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        
                        Text("Try adjusting your search or filters")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.05))
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(filteredProducts) { product in
                                ProductCard(product: product)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
            .sheet(isPresented: $showingCart) {
                CartView()
            }
            .sheet(isPresented: $showingFavorites) {
                FavoritesView()
            }
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}



#Preview {
    HomeView()
        .environmentObject(AuthManager())
        .environmentObject(CartManager())
        .environmentObject(FavoritesManager())
} 
