import XCTest
@testable import CusrsorTesting

class AuthManagerTests: XCTestCase {
    var authManager: AuthManager!
    
    override func setUp() {
        super.setUp()
        authManager = AuthManager()
    }
    
    override func tearDown() {
        authManager = nil
        super.tearDown()
    }
    
    // MARK: - Sign In Tests
    
    func testSignInWithValidCredentials() {
        // Given
        let email = "demo@example.com"
        let password = "password123"
        
        // When
        authManager.signIn(email: email, password: password)
        
        // Then
        let expectation = XCTestExpectation(description: "Sign in completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertTrue(self.authManager.isAuthenticated)
            XCTAssertNotNil(self.authManager.currentUser)
            XCTAssertEqual(self.authManager.currentUser?.email, email)
            XCTAssertEqual(self.authManager.currentUser?.name, "Demo User")
            XCTAssertTrue(self.authManager.errorMessage.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSignInWithInvalidEmail() {
        // Given
        let email = "invalid@example.com"
        let password = "password123"
        
        // When
        authManager.signIn(email: email, password: password)
        
        // Then
        let expectation = XCTestExpectation(description: "Sign in failure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(self.authManager.isAuthenticated)
            XCTAssertNil(self.authManager.currentUser)
            XCTAssertEqual(self.authManager.errorMessage, "Invalid email or password")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSignInWithInvalidPassword() {
        // Given
        let email = "demo@example.com"
        let password = "wrongpassword"
        
        // When
        authManager.signIn(email: email, password: password)
        
        // Then
        let expectation = XCTestExpectation(description: "Sign in failure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(self.authManager.isAuthenticated)
            XCTAssertNil(self.authManager.currentUser)
            XCTAssertEqual(self.authManager.errorMessage, "Invalid email or password")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSignInWithEmptyCredentials() {
        // Given
        let email = ""
        let password = ""
        
        // When
        authManager.signIn(email: email, password: password)
        
        // Then
        let expectation = XCTestExpectation(description: "Sign in failure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(self.authManager.isAuthenticated)
            XCTAssertNil(self.authManager.currentUser)
            XCTAssertEqual(self.authManager.errorMessage, "Invalid email or password")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Sign Up Tests
    
    func testSignUpWithValidCredentials() {
        // Given
        let email = "newuser@example.com"
        let password = "newpassword123"
        let name = "New User"
        
        // When
        authManager.signUp(email: email, password: password, name: name)
        
        // Then
        let expectation = XCTestExpectation(description: "Sign up completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertTrue(self.authManager.isAuthenticated)
            XCTAssertNotNil(self.authManager.currentUser)
            XCTAssertEqual(self.authManager.currentUser?.email, email)
            XCTAssertEqual(self.authManager.currentUser?.name, name)
            XCTAssertTrue(self.authManager.errorMessage.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSignUpWithExistingEmail() {
        // Given
        let email = "demo@example.com"
        let password = "password123"
        let name = "Demo User"
        
        // When
        authManager.signUp(email: email, password: password, name: name)
        
        // Then
        let expectation = XCTestExpectation(description: "Sign up failure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(self.authManager.isAuthenticated)
            XCTAssertNil(self.authManager.currentUser)
            XCTAssertEqual(self.authManager.errorMessage, "User with this email already exists")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSignUpWithEmptyFields() {
        // Given
        let email = ""
        let password = ""
        let name = ""
        
        // When
        authManager.signUp(email: email, password: password, name: name)
        
        // Then
        let expectation = XCTestExpectation(description: "Sign up failure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(self.authManager.isAuthenticated)
            XCTAssertNil(self.authManager.currentUser)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Sign Out Tests
    
    func testSignOut() {
        // Given - First sign in
        authManager.signIn(email: "demo@example.com", password: "password123")
        
        let signInExpectation = XCTestExpectation(description: "Sign in completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertTrue(self.authManager.isAuthenticated)
            signInExpectation.fulfill()
        }
        wait(for: [signInExpectation], timeout: 2.0)
        
        // When
        authManager.signOut()
        
        // Then
        XCTAssertFalse(authManager.isAuthenticated)
        XCTAssertNil(authManager.currentUser)
    }
    
    // MARK: - User Update Tests
    
    func testUpdateUser() {
        // Given - First sign in
        authManager.signIn(email: "demo@example.com", password: "password123")
        
        let signInExpectation = XCTestExpectation(description: "Sign in completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            signInExpectation.fulfill()
        }
        wait(for: [signInExpectation], timeout: 2.0)
        
        // When
        let updatedUser = User(
            id: authManager.currentUser?.id ?? "",
            email: "updated@example.com",
            password: "password123",
            name: "Updated User",
            phone: "+1234567890",
            address: "123 Updated St"
        )
        authManager.updateUser(updatedUser)
        
        // Then
        XCTAssertEqual(authManager.currentUser?.email, "updated@example.com")
        XCTAssertEqual(authManager.currentUser?.name, "Updated User")
        XCTAssertEqual(authManager.currentUser?.phone, "+1234567890")
        XCTAssertEqual(authManager.currentUser?.address, "123 Updated St")
    }
    
    // MARK: - Loading State Tests
    
    func testLoadingStateDuringSignIn() {
        // Given
        let email = "demo@example.com"
        let password = "password123"
        
        // When
        authManager.signIn(email: email, password: password)
        
        // Then - Should be loading immediately
        XCTAssertTrue(authManager.isLoading)
        
        // Wait for completion
        let expectation = XCTestExpectation(description: "Loading completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(self.authManager.isLoading)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testLoadingStateDuringSignUp() {
        // Given
        let email = "newuser@example.com"
        let password = "newpassword123"
        let name = "New User"
        
        // When
        authManager.signUp(email: email, password: password, name: name)
        
        // Then - Should be loading immediately
        XCTAssertTrue(authManager.isLoading)
        
        // Wait for completion
        let expectation = XCTestExpectation(description: "Loading completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(self.authManager.isLoading)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
} 