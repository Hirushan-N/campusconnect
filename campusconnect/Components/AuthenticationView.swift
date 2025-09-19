//
//  AuthenticationView.swift
//  campusconnect
//
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var authManager = BiometricAuthenticationManager.shared
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                // Main app content
                NavigationStack {
                    HomeView()
                }
            } else {
                // Login screen
                LoginView()
            }
        }
        .onAppear {
            // Check if user is already authenticated (for app launch)
            // In a real app, you might want to check for stored authentication state
            // For now, we'll start with authentication required
        }
    }
}

// Preview
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
