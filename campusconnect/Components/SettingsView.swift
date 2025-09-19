import SwiftUI

struct SettingsView: View {
    @StateObject private var authManager = BiometricAuthenticationManager.shared
    @State private var showLogoutAlert = false
    @State private var showReAuthAlert = false
    @Environment(\.dismiss) private var dismiss

    @ScaledMetric(relativeTo: .body) private var iconWidth: CGFloat = 30
    @ScaledMetric(relativeTo: .body) private var rowVPad: CGFloat = 4

    var body: some View {
        NavigationView {
            List {
                // Security Section
                Section("Security") {
                    HStack {
                        Image(systemName: authManager.biometricIconName)
                            .foregroundColor(.blue)
                            .frame(width: iconWidth)

                        VStack(alignment: .leading) {
                            Text("Biometric Authentication")
                                .font(.headline) // semantic, scales
                            Text(authManager.biometricType == .none ? "Not Available" : "Enabled")
                                .font(.caption)  // semantic, scales
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        if authManager.biometricType != .none {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.vertical, rowVPad)

                    Button(action: { showReAuthAlert = true }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.orange)
                                .frame(width: iconWidth)

                            Text("Re-authenticate")
                                .foregroundColor(.primary)
                                .font(.body) // semantic
                            Spacer()
                        }
                    }
                    .padding(.vertical, rowVPad)
                }

                // Account Section
                Section("Account") {
                    Button(action: { showLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                                .frame(width: iconWidth)

                            Text("Logout")
                                .foregroundColor(.red)
                                .font(.body)
                            Spacer()
                        }
                    }
                    .padding(.vertical, rowVPad)
                }

                // App Information Section
                Section("App Information") {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                            .frame(width: iconWidth)

                        VStack(alignment: .leading) {
                            Text("Version")
                                .font(.headline)
                            Text("1.0.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, rowVPad)

                    HStack {
                        Image(systemName: "shield.checkered")
                            .foregroundColor(.green)
                            .frame(width: iconWidth)

                        VStack(alignment: .leading) {
                            Text("Security Status")
                                .font(.headline)
                            Text("Protected with Biometric Authentication")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, rowVPad)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .alert("Re-authenticate", isPresented: $showReAuthAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Authenticate") {
                if authManager.biometricType != .none {
                    authManager.authenticateWithBiometrics()
                } else {
                    
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
        Group {
            SettingsView()
                .previewDisplayName("Default")

            // Preview with larger Dynamic Type
            SettingsView()
                .environment(\.dynamicTypeSize, .accessibility3)
                .previewDisplayName("Large Text")
        }
    }
}
