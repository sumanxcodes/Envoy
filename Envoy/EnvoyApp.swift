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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
