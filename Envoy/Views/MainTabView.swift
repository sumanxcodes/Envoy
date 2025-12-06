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
            Tab("Home", systemImage: "map.fill", value: "Home") {
                MapView()
            }
            
            Tab("Trips", systemImage: "briefcase.fill", value: "Trips") {
                TripsView()
            }
            
            Tab("Profile", systemImage: "person.fill", value: "Profile") {
                ProfileView()
            }
            
            Tab("Chat", systemImage: "bubble.left.and.bubble.right.fill", value: "Chat", role: .search) {
                Color.clear // Placeholder, content shown in sheet
            }
        }
        .tabViewStyle(.sidebarAdaptable)
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
