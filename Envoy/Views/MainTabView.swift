import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: String = "Home"
    @State private var showChat = false
    
    var body: some View {
        TabView(selection: Binding(
            get: { selectedTab },
            set: { newValue in
                if newValue == "Chat" {
                    showChat = true
                } else {
                    selectedTab = newValue
                }
            }
        )) {
            Tab("Home", systemImage: "house.fill", value: "Home") {
                if #available(iOS 26.0, *) {
                    MapView()
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "map")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("Maps require iOS 26 or newer")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
                }
            }
            
            Tab("Trips", systemImage: "briefcase.fill", value: "Trips") {
                TripsView()
            }
            
            Tab("Settings", systemImage: "gear", value: "Settings") {
                SettingsView()
            }
            
            Tab("Chat", systemImage: "message.fill", value: "Chat", role: .search) {
                Color.clear // Placeholder, content shown in sheet
            }
        }

        .tabViewStyle(.sidebarAdaptable)
        .tint(AppTheme.tint)
        .toolbarBackground(.thickMaterial, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .onAppear {
            // Customize tab bar appearance for glass effect
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterialDark)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .sheet(isPresented: $showChat) {
            NavigationStack {
                ChatView()
                    .navigationTitle("Chat")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: { showChat = false }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                                    
                            }
                        }
                    }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    MainTabView()
}
