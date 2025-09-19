//
//  BiometricAuthenticationManager.swift
//  campusconnect
//
//

import Foundation
import LocalAuthentication
import SwiftUI

class BiometricAuthenticationManager: ObservableObject {
    static let shared = BiometricAuthenticationManager()
    
    @Published var isAuthenticated = false
    @Published var authenticationError: String?
    @Published var biometricType: LABiometryType = .none
    
    private let context = LAContext()
    
    private init() {
        checkBiometricAvailability()
    }
    
    func checkBiometricAvailability() {
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            biometricType = context.biometryType
        } else {
            biometricType = .none
        }
    }
    
    func authenticateWithBiometrics() {
        let reason = "Use Face ID or Touch ID to access Campus Connect"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
            DispatchQueue.main.async {
                print("🔐 Biometric authentication result: \(success)")
                if success {
                    self?.isAuthenticated = true
                    self?.authenticationError = nil
                    print("✅ Authentication successful - navigating to home")
                } else {
                    self?.isAuthenticated = false
                    if let error = error as? LAError {
                        self?.authenticationError = self?.getBiometricErrorMessage(for: error)
                        print("❌ Authentication failed: \(error.localizedDescription)")
                    } else {
                        self?.authenticationError = "Authentication failed. Please try again."
                        print("❌ Authentication failed: Unknown error")
                    }
                }
            }
        }
    }
    
    func authenticateWithPasscode() {
        let reason = "Enter your passcode to access Campus Connect"
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, error in
            DispatchQueue.main.async {
                print("🔐 Passcode authentication result: \(success)")
                if success {
                    self?.isAuthenticated = true
                    self?.authenticationError = nil
                    print("✅ Passcode authentication successful - navigating to home")
                } else {
                    self?.isAuthenticated = false
                    if let error = error as? LAError {
                        self?.authenticationError = self?.getPasscodeErrorMessage(for: error)
                        print("❌ Passcode authentication failed: \(error.localizedDescription)")
                    } else {
                        self?.authenticationError = "Authentication failed. Please try again."
                        print("❌ Passcode authentication failed: Unknown error")
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
            return "User chose to use passcode instead."
        case .biometryNotAvailable:
            return "Biometric authentication is not available on this device."
        case .biometryNotEnrolled:
            return "No biometric data is enrolled. Please set up Face ID or Touch ID in Settings."
        case .biometryLockout:
            return "Biometric authentication is locked. Please use your passcode to unlock."
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
    
    private func getPasscodeErrorMessage(for error: LAError) -> String {
        switch error.code {
        case .userCancel:
            return "Authentication was cancelled."
        case .userFallback:
            return "User chose to use biometric authentication instead."
        case .systemCancel:
            return "Authentication was cancelled by the system."
        case .appCancel:
            return "Authentication was cancelled by the app."
        case .invalidContext:
            return "Authentication context is invalid."
        case .notInteractive:
            return "Authentication is not interactive."
        default:
            return "Passcode authentication failed. Please try again."
        }
    }
    
    var biometricIconName: String {
        switch biometricType {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        default:
            return "key.fill"
        }
    }
    
    var biometricButtonText: String {
        switch biometricType {
        case .faceID:
            return "Use Face ID"
        case .touchID:
            return "Use Touch ID"
        default:
            return "Use Passcode"
        }
    }
}
