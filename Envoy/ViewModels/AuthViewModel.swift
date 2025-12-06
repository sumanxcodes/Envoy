import Foundation
import SwiftUI
import Supabase
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var session: Session?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Access client lazily to avoid initializing SupabaseService during app launch
    private var client: SupabaseClient {
        SupabaseService.shared.client
    }
    
    // Removed init to avoid side effects during initialization
    // Call initializeSession() from the view's .task modifier instead
    
    func initializeSession() async {
        // Initialize session on MainActor (should be fast now)
        do {
            self.session = try await client.auth.session
        } catch {
            print("No initial session found: \(error)")
        }
        
        // Capture client locally to avoid accessing SupabaseService.shared in detached task
        let authClient = client.auth
        
        // Listen for auth state changes in a detached task
        Task.detached { [weak self] in
            guard let self = self else { return }
            
            var lastSessionId: UUID?
            var lastAccessToken: String?
            
            for await state in authClient.authStateChanges {
                let newSessionId = state.session?.user.id
                let newAccessToken = state.session?.accessToken
                
                if newSessionId != lastSessionId || newAccessToken != lastAccessToken {
                    lastSessionId = newSessionId
                    lastAccessToken = newAccessToken
                    
                    await self.updateSession(state.session)
                }
            }
        }
    }
    

    
    @MainActor
    private func updateSession(_ session: Session?) {
        self.session = session
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
    
    @Published var awaitingVerification = false
    
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let response = try await client.auth.signUp(email: email, password: password)
            
            // If session is nil, it means email confirmation is required
            if response.session == nil {
                awaitingVerification = true
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func verifyOTP(email: String, token: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            _ = try await client.auth.verifyOTP(
                email: email,
                token: token,
                type: .signup
            )
            awaitingVerification = false
        } catch {
            errorMessage = "Verification failed: \(error.localizedDescription)"
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
