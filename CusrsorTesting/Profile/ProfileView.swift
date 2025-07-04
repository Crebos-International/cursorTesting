//
//  ProfileView.swift
//  CusrsorTesting
//
//  Created by Himank Bansal on 02/07/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var favoritesManager: FavoritesManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingFavorites = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Profile header
                VStack(spacing: 15) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text(authManager.currentUser?.name ?? "User")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(authManager.currentUser?.email ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Additional user info
                    if let user = authManager.currentUser {
                        VStack(spacing: 8) {
                            if let phone = user.phone {
                                HStack {
                                    Image(systemName: "phone")
                                        .foregroundColor(.gray)
                                        .frame(width: 16)
                                    Text(phone)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            if let address = user.address {
                                HStack {
                                    Image(systemName: "location")
                                        .foregroundColor(.gray)
                                        .frame(width: 16)
                                    Text(address)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.top, 50)
                
                // Profile options
                VStack(spacing: 0) {
                    ProfileOptionRow(icon: "person", title: "Edit Profile", action: { showingEditProfile = true })
                    ProfileOptionRow(
                        icon: "heart", 
                        title: "Favorites", 
                        subtitle: "\(favoritesManager.totalFavorites) items",
                        action: { showingFavorites = true }
                    )
                    ProfileOptionRow(icon: "bag", title: "My Orders", action: {})
                    ProfileOptionRow(icon: "gear", title: "Settings", action: {})
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                Spacer()
                
                // Sign out button
                Button(action: {
                    authManager.signOut()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Sign Out")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingFavorites) {
                FavoritesView()
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
        }
    }
}

struct ProfileOptionRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let action: () -> Void
    
    init(icon: String, title: String, subtitle: String? = nil, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundColor(.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
        
        Divider()
            .padding(.leading, 56)
    }
}
