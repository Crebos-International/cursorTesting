import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isSignUp = false
    @State private var email = "demo@example.com"
    @State private var password = "password123"
    @State private var name = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // App Logo/Title
                        VStack(spacing: 10) {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            
                            Text("StyleStore")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Your Fashion Destination")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 50)
                        
                        // Auth Form
                        VStack(spacing: 20) {
                            // Toggle between Sign In and Sign Up
                            Picker("Auth Mode", selection: $isSignUp) {
                                Text("Sign In").tag(false)
                                Text("Sign Up").tag(true)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                if isSignUp {
                                    // Name field for sign up
                                    TextField("Full Name", text: $name)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                                
                                // Email field
                                TextField("Email", text: $email)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                
                                // Password field
                                SecureField("Password", text: $password)
                                    .textFieldStyle(CustomTextFieldStyle())
                                
                                if isSignUp {
                                    // Confirm password field
                                    SecureField("Confirm Password", text: $confirmPassword)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                            }
                            .padding(.horizontal)
                            
                            // Error message
                            if !authManager.errorMessage.isEmpty {
                                Text(authManager.errorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            // Action button
                            Button(action: performAuthAction) {
                                HStack {
                                    if authManager.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    }
                                    
                                    Text(isSignUp ? "Create Account" : "Sign In")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.red]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                            }
                            .disabled(authManager.isLoading || !isFormValid)
                            .opacity(isFormValid ? 1.0 : 0.6)
                            .padding(.horizontal)
                            
                            // Demo credentials hint
                            if !isSignUp {
                                VStack(spacing: 5) {
                                    Text("Demo Credentials:")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("Email: demo@example.com")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("Password: password123")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .padding(.top, 10)
                            }
                        }
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var isFormValid: Bool {
        if isSignUp {
            return !email.isEmpty && !password.isEmpty && !name.isEmpty && 
                   password == confirmPassword && password.count >= 6
        } else {
            return !email.isEmpty && !password.isEmpty
        }
    }
    
    private func performAuthAction() {
        if isSignUp {
            authManager.signUp(email: email, password: password, name: name)
        } else {
            authManager.signIn(email: email, password: password)
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(10)
            .shadow(radius: 2)
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthManager())
} 
