import SwiftUI
import Supabase

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                // User Profile Section
                Section {
                    HStack(spacing: 15) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(AppTheme.secondaryLabel)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            if let email = authViewModel.session?.user.email {
                                Text(email.components(separatedBy: "@").first?.capitalized ?? "User")
                                    .font(AppTypography.title2)
                                    .foregroundColor(AppTheme.label)
                                Text(email)
                                    .font(AppTypography.subheadline)
                                    .foregroundColor(AppTheme.secondaryLabel)
                            } else {
                                Text("Guest User")
                                    .font(AppTypography.title2)
                                    .foregroundColor(AppTheme.label)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Preferences Section
                Section(header: Text("Preferences")) {
                    SettingsRow(icon: "map.fill", color: .green, title: "Map Style")
                    SettingsRow(icon: "ruler.fill", color: .orange, title: "Distance Units")
                    SettingsRow(icon: "bell.fill", color: .red, title: "Notifications")
                }
                
                // Data Section
                Section(header: Text("Data")) {
                    SettingsRow(icon: "clock.fill", color: .blue, title: "Chat History")
                    SettingsRow(icon: "bookmark.fill", color: .purple, title: "Saved Places")
                }
                
                // Support Section
                Section(header: Text("Support")) {
                    SettingsRow(icon: "questionmark.circle.fill", color: .gray, title: "Help & Support")
                    SettingsRow(icon: "info.circle.fill", color: .gray, title: "About Envoy")
                }
                
                // Sign Out Section
                Section {
                    Button(action: {
                        Task {
                            await authViewModel.signOut()
                        }
                    }) {
                        Text("Sign Out")
                            .foregroundColor(AppTheme.destructive)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let color: Color
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(color)
                .cornerRadius(6)
            
            Text(title)
                .font(AppTypography.body)
                .foregroundColor(AppTheme.label)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.tertiaryLabel)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
}
