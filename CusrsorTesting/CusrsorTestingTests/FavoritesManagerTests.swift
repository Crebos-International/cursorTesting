import XCTest
@testable import CusrsorTesting

class FavoritesManagerTests: XCTestCase {
    var favoritesManager: FavoritesManager!
    var sampleProduct: Product!
    
    override func setUp() {
        super.setUp()
        favoritesManager = FavoritesManager()
        sampleProduct = Product(
            id: "1",
            name: "Test Product",
            description: "Test Description",
            price: 29.99,
            imageName: "test",
            category: .clothing,
            gender: .men,
            rating: 4.5,
            isOnSale: false,
            salePrice: nil
        )
    }
    
    override func tearDown() {
        favoritesManager = nil
        sampleProduct = nil
        super.tearDown()
    }
    
    // MARK: - Add to Favorites Tests
    
    func testAddToFavorites() {
        // When
        favoritesManager.addToFavorites(sampleProduct)
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 1)
        XCTAssertEqual(favoritesManager.totalFavorites, 1)
        XCTAssertEqual(favoritesManager.favoriteProducts.first?.id, sampleProduct.id)
    }
    
    func testAddToFavoritesMultipleTimes() {
        // When
        favoritesManager.addToFavorites(sampleProduct)
        favoritesManager.addToFavorites(sampleProduct)
        favoritesManager.addToFavorites(sampleProduct)
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 1)
        XCTAssertEqual(favoritesManager.totalFavorites, 1)
    }
    
    func testAddToFavoritesDifferentProducts() {
        // Given
        let product2 = Product(
            id: "2",
            name: "Test Product 2",
            description: "Test Description 2",
            price: 49.99,
            imageName: "test2",
            category: .shoes,
            gender: .women,
            rating: 4.0,
            isOnSale: false,
            salePrice: nil
        )
        
        // When
        favoritesManager.addToFavorites(sampleProduct)
        favoritesManager.addToFavorites(product2)
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 2)
        XCTAssertEqual(favoritesManager.totalFavorites, 2)
    }
    
    // MARK: - Remove from Favorites Tests
    
    func testRemoveFromFavorites() {
        // Given
        favoritesManager.addToFavorites(sampleProduct)
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 1)
        
        // When
        favoritesManager.removeFromFavorites(sampleProduct)
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 0)
        XCTAssertEqual(favoritesManager.totalFavorites, 0)
    }
    
    func testRemoveFromFavoritesWhenEmpty() {
        // When
        favoritesManager.removeFromFavorites(sampleProduct)
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 0)
        XCTAssertEqual(favoritesManager.totalFavorites, 0)
    }
    
    // MARK: - Toggle Favorite Tests
    
    func testToggleFavoriteAdd() {
        // When
        favoritesManager.toggleFavorite(sampleProduct)
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 1)
        XCTAssertEqual(favoritesManager.totalFavorites, 1)
        XCTAssertTrue(favoritesManager.isFavorite(sampleProduct))
    }
    
    func testToggleFavoriteRemove() {
        // Given
        favoritesManager.addToFavorites(sampleProduct)
        XCTAssertTrue(favoritesManager.isFavorite(sampleProduct))
        
        // When
        favoritesManager.toggleFavorite(sampleProduct)
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 0)
        XCTAssertEqual(favoritesManager.totalFavorites, 0)
        XCTAssertFalse(favoritesManager.isFavorite(sampleProduct))
    }
    
    // MARK: - Is Favorite Tests
    
    func testIsFavoriteTrue() {
        // Given
        favoritesManager.addToFavorites(sampleProduct)
        
        // When
        let isFavorite = favoritesManager.isFavorite(sampleProduct)
        
        // Then
        XCTAssertTrue(isFavorite)
    }
    
    func testIsFavoriteFalse() {
        // When
        let isFavorite = favoritesManager.isFavorite(sampleProduct)
        
        // Then
        XCTAssertFalse(isFavorite)
    }
    
    func testIsFavoriteWithDifferentProduct() {
        // Given
        favoritesManager.addToFavorites(sampleProduct)
        
        let differentProduct = Product(
            id: "999",
            name: "Different Product",
            description: "Different Description",
            price: 10.0,
            imageName: "different",
            category: .clothing,
            gender: .men,
            rating: 4.0,
            isOnSale: false,
            salePrice: nil
        )
        
        // When
        let isFavorite = favoritesManager.isFavorite(differentProduct)
        
        // Then
        XCTAssertFalse(isFavorite)
    }
    
    // MARK: - Clear Favorites Tests
    
    func testClearFavorites() {
        // Given
        favoritesManager.addToFavorites(sampleProduct)
        
        let product2 = Product(
            id: "2",
            name: "Test Product 2",
            description: "Test Description 2",
            price: 49.99,
            imageName: "test2",
            category: .shoes,
            gender: .women,
            rating: 4.0,
            isOnSale: false,
            salePrice: nil
        )
        favoritesManager.addToFavorites(product2)
        
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 2)
        
        // When
        favoritesManager.clearFavorites()
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 0)
        XCTAssertEqual(favoritesManager.totalFavorites, 0)
    }
    
    func testClearFavoritesWhenEmpty() {
        // When
        favoritesManager.clearFavorites()
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 0)
        XCTAssertEqual(favoritesManager.totalFavorites, 0)
    }
    
    // MARK: - Filter Tests
    
    func testGetFavoritesForGender() {
        // Given
        let menProduct = Product(
            id: "1",
            name: "Men Product",
            description: "Men Description",
            price: 29.99,
            imageName: "men",
            category: .clothing,
            gender: .men,
            rating: 4.5,
            isOnSale: false,
            salePrice: nil
        )
        
        let womenProduct = Product(
            id: "2",
            name: "Women Product",
            description: "Women Description",
            price: 49.99,
            imageName: "women",
            category: .shoes,
            gender: .women,
            rating: 4.0,
            isOnSale: false,
            salePrice: nil
        )
        
        favoritesManager.addToFavorites(menProduct)
        favoritesManager.addToFavorites(womenProduct)
        
        // When
        let menFavorites = favoritesManager.getFavorites(for: .men)
        let womenFavorites = favoritesManager.getFavorites(for: .women)
        let allFavorites = favoritesManager.getFavorites()
        
        // Then
        XCTAssertEqual(menFavorites.count, 1)
        XCTAssertEqual(womenFavorites.count, 1)
        XCTAssertEqual(allFavorites.count, 2)
        XCTAssertEqual(menFavorites.first?.gender, .men)
        XCTAssertEqual(womenFavorites.first?.gender, .women)
    }
    
    func testGetFavoritesForCategory() {
        // Given
        let clothingProduct = Product(
            id: "1",
            name: "Clothing Product",
            description: "Clothing Description",
            price: 29.99,
            imageName: "clothing",
            category: .clothing,
            gender: .men,
            rating: 4.5,
            isOnSale: false,
            salePrice: nil
        )
        
        let shoesProduct = Product(
            id: "2",
            name: "Shoes Product",
            description: "Shoes Description",
            price: 49.99,
            imageName: "shoes",
            category: .shoes,
            gender: .women,
            rating: 4.0,
            isOnSale: false,
            salePrice: nil
        )
        
        favoritesManager.addToFavorites(clothingProduct)
        favoritesManager.addToFavorites(shoesProduct)
        
        // When
        let clothingFavorites = favoritesManager.getFavorites(for: .clothing)
        let shoesFavorites = favoritesManager.getFavorites(for: .shoes)
        let allFavorites = favoritesManager.getFavorites()
        
        // Then
        XCTAssertEqual(clothingFavorites.count, 1)
        XCTAssertEqual(shoesFavorites.count, 1)
        XCTAssertEqual(allFavorites.count, 2)
        XCTAssertEqual(clothingFavorites.first?.category, .clothing)
        XCTAssertEqual(shoesFavorites.first?.category, .shoes)
    }
    
    // MARK: - Edge Cases
    
    func testEmptyFavorites() {
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 0)
        XCTAssertEqual(favoritesManager.totalFavorites, 0)
        XCTAssertFalse(favoritesManager.isFavorite(sampleProduct))
    }
    
    func testMultipleOperations() {
        // Given
        let product1 = Product(
            id: "1",
            name: "Product 1",
            description: "Description 1",
            price: 10.0,
            imageName: "test1",
            category: .clothing,
            gender: .men,
            rating: 4.0,
            isOnSale: false,
            salePrice: nil
        )
        
        let product2 = Product(
            id: "2",
            name: "Product 2",
            description: "Description 2",
            price: 20.0,
            imageName: "test2",
            category: .shoes,
            gender: .women,
            rating: 4.0,
            isOnSale: false,
            salePrice: nil
        )
        
        let product3 = Product(
            id: "3",
            name: "Product 3",
            description: "Description 3",
            price: 30.0,
            imageName: "test3",
            category: .accessories,
            gender: .unisex,
            rating: 4.0,
            isOnSale: false,
            salePrice: nil
        )
        
        // When - Add all products
        favoritesManager.addToFavorites(product1)
        favoritesManager.addToFavorites(product2)
        favoritesManager.addToFavorites(product3)
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 3)
        XCTAssertEqual(favoritesManager.totalFavorites, 3)
        
        // When - Remove one product
        favoritesManager.removeFromFavorites(product2)
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 2)
        XCTAssertEqual(favoritesManager.totalFavorites, 2)
        XCTAssertTrue(favoritesManager.isFavorite(product1))
        XCTAssertFalse(favoritesManager.isFavorite(product2))
        XCTAssertTrue(favoritesManager.isFavorite(product3))
        
        // When - Toggle one product
        favoritesManager.toggleFavorite(product1)
        
        // Then
        XCTAssertEqual(favoritesManager.favoriteProducts.count, 1)
        XCTAssertEqual(favoritesManager.totalFavorites, 1)
        XCTAssertFalse(favoritesManager.isFavorite(product1))
        XCTAssertTrue(favoritesManager.isFavorite(product3))
    }
} 