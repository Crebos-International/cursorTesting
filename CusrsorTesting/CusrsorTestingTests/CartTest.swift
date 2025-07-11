//
//  CartTest.swift
//  CusrsorTesting
//
//  Created by Himank Bansal on 11/07/25.
//

import XCTest
@testable import CusrsorTesting

final class CartTest: XCTestCase {
    var cartManager: CartManager!
    var sampleProduct: Product!
    
    override func setUp() {
        super.setUp()
        cartManager = CartManager()
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
        cartManager = nil
        sampleProduct = nil
        super.tearDown()
    }
    
    // MARK: - Add to Cart Tests
    
    func testAddToCart() {
        // When
        cartManager.addToCart(sampleProduct)
        
        // Then
        XCTAssertEqual(cartManager.cartItems.count, 1)
        XCTAssertEqual(cartManager.totalItems, 1)
        XCTAssertEqual(cartManager.cartItems.first?.product.id, sampleProduct.id)
        XCTAssertEqual(cartManager.cartItems.first?.quantity, 1)
    }
    
    func testAddToCartMultipleTimes() {
        // When
        cartManager.addToCart(sampleProduct)
        cartManager.addToCart(sampleProduct)
        cartManager.addToCart(sampleProduct)
        
        // Then
        XCTAssertEqual(cartManager.cartItems.count, 1)
        XCTAssertEqual(cartManager.totalItems, 3)
        XCTAssertEqual(cartManager.cartItems.first?.quantity, 3)
    }
    
    func testAddToCartDifferentProducts() {
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
        cartManager.addToCart(sampleProduct)
        cartManager.addToCart(product2)
        
        // Then
        XCTAssertEqual(cartManager.cartItems.count, 2)
        XCTAssertEqual(cartManager.totalItems, 2)
    }
    
    // MARK: - Remove from Cart Tests
    
    func testRemoveFromCart() {
        // Given
        cartManager.addToCart(sampleProduct)
        XCTAssertEqual(cartManager.cartItems.count, 1)
        
        // When
        cartManager.removeFromCart(sampleProduct)
        
        // Then
        XCTAssertEqual(cartManager.cartItems.count, 0)
        XCTAssertEqual(cartManager.totalItems, 0)
    }
    
    func testRemoveFromCartWhenEmpty() {
        // When
        cartManager.removeFromCart(sampleProduct)
        
        // Then
        XCTAssertEqual(cartManager.cartItems.count, 0)
        XCTAssertEqual(cartManager.totalItems, 0)
    }
    
    // MARK: - Update Quantity Tests
    
    func testUpdateQuantityIncrease() {
        // Given
        cartManager.addToCart(sampleProduct)
        
        // When
        cartManager.updateQuantity(for: sampleProduct, quantity: 5)
        
        // Then
        XCTAssertEqual(cartManager.cartItems.first?.quantity, 5)
        XCTAssertEqual(cartManager.totalItems, 5)
    }
    
    func testUpdateQuantityDecrease() {
        // Given
        cartManager.addToCart(sampleProduct)
        cartManager.addToCart(sampleProduct) // Now quantity is 2
        
        // When
        cartManager.updateQuantity(for: sampleProduct, quantity: 1)
        
        // Then
        XCTAssertEqual(cartManager.cartItems.first?.quantity, 1)
        XCTAssertEqual(cartManager.totalItems, 1)
    }
    
    func testUpdateQuantityToZero() {
        // Given
        cartManager.addToCart(sampleProduct)
        
        // When
        cartManager.updateQuantity(for: sampleProduct, quantity: 0)
        
        // Then
        XCTAssertEqual(cartManager.cartItems.count, 0)
        XCTAssertEqual(cartManager.totalItems, 0)
    }
    
    func testUpdateQuantityToNegative() {
        // Given
        cartManager.addToCart(sampleProduct)
        
        // When
        cartManager.updateQuantity(for: sampleProduct, quantity: -1)
        
        // Then
        XCTAssertEqual(cartManager.cartItems.count, 0)
        XCTAssertEqual(cartManager.totalItems, 0)
    }
    
    // MARK: - Price Calculation Tests
    
    func testSubtotalCalculation() {
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
        
        // When
        cartManager.addToCart(product1)
        cartManager.addToCart(product1) // Quantity 2
        cartManager.addToCart(product2)
        
        // Then
        XCTAssertEqual(cartManager.subtotal, 40.0) // (10 * 2) + 20
    }
    
    func testSubtotalWithSalePrice() {
        // Given
        let saleProduct = Product(
            id: "1",
            name: "Sale Product",
            description: "Sale Description",
            price: 100.0,
            imageName: "sale",
            category: .clothing,
            gender: .men,
            rating: 4.0,
            isOnSale: true,
            salePrice: 75.0
        )
        
        // When
        cartManager.addToCart(saleProduct)
        cartManager.addToCart(saleProduct) // Quantity 2
        
        // Then
        XCTAssertEqual(cartManager.subtotal, 150.0) // 75 * 2
    }
    
    func testTaxCalculation() {
        // Given
        cartManager.addToCart(sampleProduct) // Price: 29.99
        
        // When
        let expectedTax = 29.99 * 0.08 // 8% tax
        
        // Then
        XCTAssertEqual(cartManager.tax, expectedTax, accuracy: 0.01)
    }
    
    func testTotalCalculation() {
        // Given
        cartManager.addToCart(sampleProduct) // Price: 29.99
        
        // When
        let expectedSubtotal = 29.99
        let expectedTax = expectedSubtotal * 0.08
        let expectedTotal = expectedSubtotal + expectedTax
        
        // Then
        XCTAssertEqual(cartManager.total, expectedTotal, accuracy: 0.01)
    }
    
    // MARK: - Clear Cart Tests
    
    func testClearCart() {
        // Given
        cartManager.addToCart(sampleProduct)
        cartManager.addToCart(sampleProduct)
        XCTAssertEqual(cartManager.cartItems.count, 1)
        XCTAssertEqual(cartManager.totalItems, 2)
        
        // When
        cartManager.clearCart()
        
        // Then
        XCTAssertEqual(cartManager.cartItems.count, 0)
        XCTAssertEqual(cartManager.totalItems, 0)
        XCTAssertEqual(cartManager.subtotal, 0.0)
        XCTAssertEqual(cartManager.tax, 0.0)
        XCTAssertEqual(cartManager.total, 0.0)
    }
    
    // MARK: - Get Quantity Tests
    
    func testGetQuantityForExistingProduct() {
        // Given
        cartManager.addToCart(sampleProduct)
        cartManager.addToCart(sampleProduct)
        
        // When
        let quantity = cartManager.getQuantity(for: sampleProduct)
        
        // Then
        XCTAssertEqual(quantity, 2)
    }
    
    func testGetQuantityForNonExistingProduct() {
        // Given
        let nonExistingProduct = Product(
            id: "999",
            name: "Non Existing",
            description: "Non Existing Description",
            price: 10.0,
            imageName: "nonexisting",
            category: .clothing,
            gender: .men,
            rating: 4.0,
            isOnSale: false,
            salePrice: nil
        )
        
        // When
        let quantity = cartManager.getQuantity(for: nonExistingProduct)
        
        // Then
        XCTAssertEqual(quantity, 0)
    }
    
    // MARK: - Edge Cases
    
    func testEmptyCartCalculations() {
        // Then
        XCTAssertEqual(cartManager.totalItems, 0)
        XCTAssertEqual(cartManager.subtotal, 0.0)
        XCTAssertEqual(cartManager.tax, 0.0)
        XCTAssertEqual(cartManager.total, 0.0)
    }
    
    func testMultipleProductsWithDifferentQuantities() {
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
        
        // When
        cartManager.addToCart(product1)
        cartManager.addToCart(product1) // Quantity 2
        cartManager.addToCart(product2)
        cartManager.addToCart(product2) // Quantity 2
        cartManager.addToCart(product2) // Quantity 3
        
        // Then
        XCTAssertEqual(cartManager.cartItems.count, 2)
        XCTAssertEqual(cartManager.totalItems, 5)
        XCTAssertEqual(cartManager.getQuantity(for: product1), 2)
        XCTAssertEqual(cartManager.getQuantity(for: product2), 3)
        XCTAssertEqual(cartManager.subtotal, 80.0) // (10 * 2) + (20 * 3)
    }
}
