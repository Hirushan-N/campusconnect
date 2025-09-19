//
//  campusconnectApp.swift
//  campusconnect
//
//

import SwiftUI

@main
struct campusconnectApp: App {
    init() {
        _ = CoreDataStack.shared
    }
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
        }
    }
}
