import SwiftUI
import MapKit

struct MapView: View {
    @StateObject @MainActor private var mapViewModel = MapViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            // Map Layer
            MapViewRepresentable(region: $mapViewModel.region, showsUserLocation: true)
                .ignoresSafeArea()
                .onAppear {
                    mapViewModel.requestLocationPermission()
                }
            
            // Floating Controls (Right Side)
            VStack(spacing: 12) {
                Spacer()
                
                // Location Button
                Button(action: {
                    mapViewModel.centerOnUser()
                }) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppTheme.tint)
                        .frame(width: 44, height: 44)
                        .background(AppTheme.background)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.trailing, AppLayout.padding)
            .padding(.bottom, 20) // Standard padding above tab bar
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    MapView()
}
