import SwiftUI

struct AuthenticationView: View {
    @StateObject private var authManager = BiometricAuthenticationManager.shared
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                NavigationStack { HomeView() }
            } else {
                LoginView()
            }
        }
        .onAppear {
            // Auth state checks as needed
        }
    }
}

// Previews
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthenticationView()
                .previewDisplayName("Default")

            AuthenticationView()
                .environment(\.dynamicTypeSize, .accessibility3)
                .previewDisplayName("Large Text")
        }
    }
}
