//
//  SettingsView.swift
//  campusconnect
//
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var authManager = BiometricAuthenticationManager.shared
    @State private var showLogoutAlert = false
    @State private var showReAuthAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Security Section
                Section("Security") {
                    HStack {
                        Image(systemName: authManager.biometricIconName)
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading) {
                            Text("Biometric Authentication")
                                .font(.headline)
                            Text(authManager.biometricType == .none ? "Not Available" : "Enabled")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if authManager.biometricType != .none {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    Button(action: {
                        showReAuthAlert = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.orange)
                                .frame(width: 30)
                            
                            Text("Re-authenticate")
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                // Account Section
                Section("Account") {
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                                .frame(width: 30)
                            
                            Text("Logout")
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                // App Information Section
                Section("App Information") {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading) {
                            Text("Version")
                                .font(.headline)
                            Text("1.0.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        Image(systemName: "shield.checkered")
                            .foregroundColor(.green)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading) {
                            Text("Security Status")
                                .font(.headline)
                            Text("Protected with Biometric Authentication")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Re-authenticate", isPresented: $showReAuthAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Authenticate") {
                if authManager.biometricType != .none {
                    authManager.authenticateWithBiometrics()
                } else {
                    authManager.authenticateWithPasscode()
                }
            }
        } message: {
            Text("Please authenticate to verify your identity.")
        }
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                authManager.logout()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to logout? You'll need to authenticate again to access the app.")
        }
        .onAppear {
            authManager.checkBiometricAvailability()
        }
    }
}

// Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
