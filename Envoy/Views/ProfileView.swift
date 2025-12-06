import SwiftUI
import Supabase

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.tint) // Replaced .blue with AppTheme.tint
                
                if let email = authViewModel.session?.user.email {
                    Text(email)
                        .font(AppTypography.headline)
                }
                
                Button(action: {
                    Task {
                        await authViewModel.signOut()
                    }
                }) {
                    Text("Sign Out")
                        .font(AppTypography.primaryButton)
                        .foregroundColor(AppTheme.destructive)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.destructive.opacity(0.1))
                        .cornerRadius(AppLayout.cornerRadius)
                }
                .padding()
                
                Spacer()
            }
            .padding(AppLayout.padding)
            .navigationBarTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
