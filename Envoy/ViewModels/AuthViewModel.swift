import Foundation
import SwiftUI
import Supabase
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var session: Session?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let client = SupabaseService.shared.client
    
    init() {
        Task {
            await initializeSession()
        }
    }
    
    func initializeSession() async {
        do {
            self.session = try await client.auth.session
        } catch {
            // No session found, which is fine
            print("No initial session found: \(error)")
        }
        
        // Listen for auth state changes
        for await state in client.auth.authStateChanges {
            self.session = state.session
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            _ = try await client.auth.signIn(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            _ = try await client.auth.signUp(email: email, password: password)
            // Note: Depending on Supabase settings, email confirmation might be required.
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signOut() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await client.auth.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
