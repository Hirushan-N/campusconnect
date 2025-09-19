import Foundation
import LocalAuthentication
import SwiftUI

class BiometricAuthenticationManager: ObservableObject {
    static let shared = BiometricAuthenticationManager()
    
    @Published var isAuthenticated = false
    @Published var authenticationError: String?
    @Published var biometricType: LABiometryType = .none
    
    private let availabilityContext = LAContext()
    
    private init() {
        checkBiometricAvailability()
    }
    
    func checkBiometricAvailability() {
        let ctx = LAContext()
        var error: NSError?
        if ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            biometricType = ctx.biometryType
        } else {
            biometricType = .none
        }
    }

    
    func authenticateWithBiometrics() {
        let context = LAContext()
        context.localizedFallbackTitle = ""
        let reason = "Use Face ID or Touch ID to access Campus Connect"
        
        var authError: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else {
            DispatchQueue.main.async {
                self.isAuthenticated = false
                if let e = authError as? LAError {
                    self.authenticationError = self.getBiometricErrorMessage(for: e)
                } else {
                    self.authenticationError = "Biometric authentication is not available on this device."
                }
            }
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthenticated = true
                    self?.authenticationError = nil
                } else {
                    self?.isAuthenticated = false
                    if let e = error as? LAError {
                        self?.authenticationError = self?.getBiometricErrorMessage(for: e)
                    } else {
                        self?.authenticationError = "Authentication failed. Please try again."
                    }
                }
            }
        }
    }
    
    
    func logout() {
        isAuthenticated = false
        authenticationError = nil
    }
    
    private func getBiometricErrorMessage(for error: LAError) -> String {
        switch error.code {
        case .userCancel:
            return "Authentication was cancelled."
        case .userFallback:
            return "Please use Face ID or Touch ID."
        case .biometryNotAvailable:
            return "Biometric authentication is not available on this device."
        case .biometryNotEnrolled:
            return "No Face ID or Touch ID is set up. Please enroll biometrics in Settings."
        case .biometryLockout:
            return "Biometrics are locked due to multiple failed attempts. Unlock your device to re‑enable Face ID/Touch ID."
        case .systemCancel:
            return "Authentication was cancelled by the system."
        case .appCancel:
            return "Authentication was cancelled by the app."
        case .invalidContext:
            return "Authentication context is invalid."
        case .notInteractive:
            return "Authentication is not interactive."
        default:
            return "Biometric authentication failed. Please try again."
        }
    }
    
    var biometricIconName: String {
        switch biometricType {
        case .faceID:  return "faceid"
        case .touchID: return "touchid"
        default:       return "exclamationmark.lock.fill"
        }
    }
    
    var biometricButtonText: String {
        switch biometricType {
        case .faceID:  return "Use Face ID"
        case .touchID: return "Use Touch ID"
        default:       return "Biometrics Unavailable"
        }
    }
}
