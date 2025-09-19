//
//  LoginView.swift
//  campusconnect
//
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authManager = BiometricAuthenticationManager.shared
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            // Background with campus branding
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // App Logo and Title
                VStack(spacing: 20) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                    
                    Text("Campus Connect")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    Text("Connect with your campus community")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Authentication Section
                VStack(spacing: 20) {
                    if authManager.biometricType != .none {
                        // Biometric Authentication Button
                        Button(action: {
                            authManager.authenticateWithBiometrics()
                        }) {
                            HStack {
                                Image(systemName: authManager.biometricIconName)
                                    .font(.title2)
                                Text(authManager.biometricButtonText)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 1)
                            Text("or")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal, 10)
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    // Passcode Authentication Button
                    Button(action: {
                        authManager.authenticateWithPasscode()
                    }) {
                        HStack {
                            Image(systemName: "key.fill")
                                .font(.title2)
                            Text("Use Passcode")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 40)
                
                // Error Message
                if let errorMessage = authManager.authenticationError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                }
                
                Spacer()
                
                // Footer
                VStack(spacing: 10) {
                    Text("Secure access to your campus community")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    Text("Your data is protected with biometric security")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            // Check if biometric authentication is available
            authManager.checkBiometricAvailability()
        }
        .alert("Authentication Error", isPresented: $showAlert) {
            Button("OK") {
                showAlert = false
            }
        } message: {
            Text(alertMessage)
        }
        .onChange(of: authManager.authenticationError) { error in
            if let error = error {
                alertMessage = error
                showAlert = true
            }
        }
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
