import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashView {
                    showSplash = false
                }
            } else {
                if authViewModel.session != nil {
                    // Main App View
                    MainTabView()
                } else {
                    LoginView()
                }
            }
        }
        .task {
            await authViewModel.initializeSession()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
