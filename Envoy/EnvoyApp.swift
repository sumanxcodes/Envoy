//
//  EnvoyApp.swift
//  Envoy
//
//  Created by Suman Raj Sharma on 6/12/2025.
//

import SwiftUI

@main
struct EnvoyApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        print("🚀🚀🚀 ENVOY APP LAUNCHED 🚀🚀🚀")
        print("📱 If you see this, console is working!")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
