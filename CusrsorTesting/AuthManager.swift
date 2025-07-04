import SwiftUI

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    // Mock user database
    private var users: [User] = [
        User(id: "1", email: "demo@example.com", password: "password123", name: "Demo User", phone: "+1 (555) 123-4567", address: "123 Main St, City, State 12345")
    ]
    
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let user = self.users.first(where: { $0.email == email && $0.password == password }) {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
            } else {
                self.errorMessage = "Invalid email or password"
                self.isLoading = false
            }
        }
    }
    
    func signUp(email: String, password: String, name: String) {
        isLoading = true
        errorMessage = ""
        
        // Check if user already exists
        if users.contains(where: { $0.email == email }) {
            errorMessage = "User with this email already exists"
            isLoading = false
            return
        }
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let newUser = User(
                id: UUID().uuidString,
                email: email,
                password: password,
                name: name
            )
            self.users.append(newUser)
            self.currentUser = newUser
            self.isAuthenticated = true
            self.isLoading = false
        }
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
    
    func updateUser(_ updatedUser: User) {
        if let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
            users[index] = updatedUser
            currentUser = updatedUser
        }
    }
}

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let password: String
    let name: String
    let phone: String?
    let address: String?
    
    init(id: String, email: String, password: String, name: String, phone: String? = nil, address: String? = nil) {
        self.id = id
        self.email = email
        self.password = password
        self.name = name
        self.phone = phone
        self.address = address
    }
} 