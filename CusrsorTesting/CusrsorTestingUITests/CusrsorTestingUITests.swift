import XCTest

class CusrsorTestingUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Authentication Tests
    
    func testSignInWithValidCredentials() throws {
        // Given
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let signInButton = app.buttons["Sign In"]
        
        // When
        emailTextField.tap()
        emailTextField.typeText("demo@example.com")
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password123")
        
        signInButton.tap()
        
        // Then - Wait for authentication to complete
        let expectation = XCTestExpectation(description: "Sign in completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Check if we're on the home screen
            let homeView = self.app.otherElements["HomeView"]
            XCTAssertTrue(homeView.exists, "Should be on home screen after successful sign in")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSignInWithInvalidCredentials() throws {
        // Given
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let signInButton = app.buttons["Sign In"]
        
        // When
        emailTextField.tap()
        emailTextField.typeText("invalid@example.com")
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("wrongpassword")
        
        signInButton.tap()
        
        // Then - Should show error message
        let expectation = XCTestExpectation(description: "Error message display")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let errorMessage = self.app.staticTexts["Invalid email or password"]
            XCTAssertTrue(errorMessage.exists, "Should display error message for invalid credentials")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSignUpFlow() throws {
        // Given
        let signUpSegment = app.segmentedControls.buttons["Sign Up"]
        let nameTextField = app.textFields["Full Name"]
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let confirmPasswordSecureTextField = app.secureTextFields["Confirm Password"]
        let createAccountButton = app.buttons["Create Account"]
        
        // When
        signUpSegment.tap()
        
        nameTextField.tap()
        nameTextField.typeText("Test User")
        
        emailTextField.tap()
        emailTextField.typeText("testuser@example.com")
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("testpassword123")
        
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText("testpassword123")
        
        createAccountButton.tap()
        
        // Then - Wait for sign up to complete
        let expectation = XCTestExpectation(description: "Sign up completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let homeView = self.app.otherElements["HomeView"]
            XCTAssertTrue(homeView.exists, "Should be on home screen after successful sign up")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    // MARK: - Navigation Tests
    
    func testNavigationToProfile() throws {
        // First sign in
        try testSignInWithValidCredentials()
        
        // Given
        let profileButton = app.buttons["person.circle.fill"]
        
        // When
        profileButton.tap()
        
        // Then
        let profileView = app.otherElements["ProfileView"]
        XCTAssertTrue(profileView.exists, "Should navigate to profile view")
        
        let profileTitle = app.staticTexts["Profile"]
        XCTAssertTrue(profileTitle.exists, "Should show profile title")
    }
    
    func testNavigationToFavorites() throws {
        // First sign in
        try testSignInWithValidCredentials()
        
        // Given
        let favoritesButton = app.buttons["heart"]
        
        // When
        favoritesButton.tap()
        
        // Then
        let favoritesView = app.otherElements["FavoritesView"]
        XCTAssertTrue(favoritesView.exists, "Should navigate to favorites view")
        
        let favoritesTitle = app.staticTexts["Favorites"]
        XCTAssertTrue(favoritesTitle.exists, "Should show favorites title")
    }
    
    func testNavigationToCart() throws {
        // First sign in
        try testSignInWithValidCredentials()
        
        // Given
        let cartButton = app.buttons["cart"]
        
        // When
        cartButton.tap()
        
        // Then
        let cartView = app.otherElements["CartView"]
        XCTAssertTrue(cartView.exists, "Should navigate to cart view")
        
        let cartTitle = app.staticTexts["Cart"]
        XCTAssertTrue(cartTitle.exists, "Should show cart title")
    }
    
    // MARK: - Cart Functionality Tests
    
    func testAddToCart() throws {
        // First sign in
        try testSignInWithValidCredentials()
        
        // Given
        let addToCartButtons = app.buttons.matching(identifier: "plus")
        
        // When
        if addToCartButtons.firstMatch.exists {
            addToCartButtons.firstMatch.tap()
        }
        
        // Then - Check if cart badge appears
        let expectation = XCTestExpectation(description: "Cart badge update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let cartBadge = self.app.staticTexts["1"]
            XCTAssertTrue(cartBadge.exists, "Should show cart badge with count 1")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testCartViewWithItems() throws {
        // First add item to cart
        try testAddToCart()
        
        // Given
        let cartButton = app.buttons["cart"]
        
        // When
        cartButton.tap()
        
        // Then
        let cartItemRow = app.otherElements["CartItemRow"]
        XCTAssertTrue(cartItemRow.exists, "Should show cart items")
        
        let checkoutButton = app.buttons["Proceed to Checkout"]
        XCTAssertTrue(checkoutButton.exists, "Should show checkout button")
    }
    
    func testCartQuantityControls() throws {
        // First add item to cart and open cart
        try testCartViewWithItems()
        
        // Given
        let plusButton = app.buttons["plus"]
        let minusButton = app.buttons["minus"]
        
        // When - Increase quantity
        plusButton.tap()
        
        // Then - Should show quantity 2
        let quantityText = app.staticTexts["2"]
        XCTAssertTrue(quantityText.exists, "Should show quantity 2")
        
        // When - Decrease quantity
        minusButton.tap()
        
        // Then - Should show quantity 1
        let quantityText1 = app.staticTexts["1"]
        XCTAssertTrue(quantityText1.exists, "Should show quantity 1")
    }
    
    // MARK: - Favorites Functionality Tests
    
    func testAddToFavorites() throws {
        // First sign in
        try testSignInWithValidCredentials()
        
        // Given
        let heartButtons = app.buttons.matching(identifier: "heart")
        
        // When - Tap first heart button (should be empty heart)
        if heartButtons.firstMatch.exists {
            heartButtons.firstMatch.tap()
        }
        
        // Then - Check if favorites badge appears
        let expectation = XCTestExpectation(description: "Favorites badge update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let favoritesBadge = self.app.staticTexts["1"]
            XCTAssertTrue(favoritesBadge.exists, "Should show favorites badge with count 1")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFavoritesViewWithItems() throws {
        // First add item to favorites
        try testAddToFavorites()
        
        // Given
        let favoritesButton = app.buttons["heart"]
        
        // When
        favoritesButton.tap()
        
        // Then
        let favoriteProductCard = app.otherElements["FavoriteProductCard"]
        XCTAssertTrue(favoriteProductCard.exists, "Should show favorite products")
        
        let clearAllButton = app.buttons["Clear All"]
        XCTAssertTrue(clearAllButton.exists, "Should show clear all button")
    }
    
    // MARK: - Search Functionality Tests
    
    func testSearchProducts() throws {
        // First sign in
        try testSignInWithValidCredentials()
        
        // Given
        let searchTextField = app.textFields["Search products..."]
        
        // When
        searchTextField.tap()
        searchTextField.typeText("T-Shirt")
        
        // Then - Should filter products
        let expectation = XCTestExpectation(description: "Search results")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Check if filtered products are shown
            let productCards = self.app.otherElements["ProductCard"]
            XCTAssertTrue(productCards.exists, "Should show filtered products")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Category Filter Tests
    
    func testCategoryFilter() throws {
        // First sign in
        try testSignInWithValidCredentials()
        
        // Given
        let clothingChip = app.buttons["Clothing"]
        
        // When
        clothingChip.tap()
        
        // Then - Should filter by clothing category
        let expectation = XCTestExpectation(description: "Category filter")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let productCards = self.app.otherElements["ProductCard"]
            XCTAssertTrue(productCards.exists, "Should show clothing products")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Gender Filter Tests
    
    func testGenderFilter() throws {
        // First sign in
        try testSignInWithValidCredentials()
        
        // Given
        let womenSegment = app.segmentedControls.buttons["Women"]
        
        // When
        womenSegment.tap()
        
        // Then - Should show women's products
        let expectation = XCTestExpectation(description: "Gender filter")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let productCards = self.app.otherElements["ProductCard"]
            XCTAssertTrue(productCards.exists, "Should show women's products")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Profile Edit Tests
    
    func testEditProfile() throws {
        // First sign in and navigate to profile
        try testSignInWithValidCredentials()
        try testNavigationToProfile()
        
        // Given
        let editProfileButton = app.buttons["Edit Profile"]
        
        // When
        editProfileButton.tap()
        
        // Then
        let editProfileView = app.otherElements["EditProfileView"]
        XCTAssertTrue(editProfileView.exists, "Should navigate to edit profile view")
        
        let editProfileTitle = app.staticTexts["Edit Profile"]
        XCTAssertTrue(editProfileTitle.exists, "Should show edit profile title")
    }
    
    func testProfileFormValidation() throws {
        // First navigate to edit profile
        try testEditProfile()
        
        // Given
        let nameTextField = app.textFields["Enter your full name"]
        let emailTextField = app.textFields["Enter your email"]
        let saveButton = app.buttons["Save Changes"]
        
        // When - Clear required fields
        nameTextField.tap()
        nameTextField.clearAndEnterText("")
        
        emailTextField.tap()
        emailTextField.clearAndEnterText("")
        
        // Then - Save button should be disabled
        XCTAssertFalse(saveButton.isEnabled, "Save button should be disabled with empty required fields")
    }
    
    // MARK: - Sign Out Test
    
    func testSignOut() throws {
        // First sign in and navigate to profile
        try testSignInWithValidCredentials()
        try testNavigationToProfile()
        
        // Given
        let signOutButton = app.buttons["Sign Out"]
        
        // When
        signOutButton.tap()
        
        // Then - Should return to auth screen
        let expectation = XCTestExpectation(description: "Sign out completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let authView = self.app.otherElements["AuthView"]
            XCTAssertTrue(authView.exists, "Should return to auth screen after sign out")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Performance Tests
    
    func testAppLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    func testHomeViewLoadPerformance() throws {
        // First sign in
        try testSignInWithValidCredentials()
        
        measure(metrics: [XCTClockMetric()]) {
            // Navigate to home view
            let homeView = app.otherElements["HomeView"]
            XCTAssertTrue(homeView.exists)
        }
    }
}

// MARK: - Helper Extensions

extension XCUIElement {
    func clearAndEnterText(_ text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
} 