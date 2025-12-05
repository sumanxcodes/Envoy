import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.session != nil {
                // Main App View (Placeholder)
                VStack {
                    Image(systemName: "map.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.teal)
                        .padding()
                    
                    Text("Welcome to Envoy")
                        .font(.title)
                        .bold()
                    
                    Text("You are logged in.")
                        .foregroundStyle(.gray)
                    
                    Button("Sign Out") {
                        Task {
                            await authViewModel.signOut()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .padding(.top)
                }
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
