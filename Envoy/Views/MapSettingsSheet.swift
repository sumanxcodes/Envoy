import SwiftUI

struct MapSettingsSheet: View {
    @Binding var mapType: MapType
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Map Modes")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
                Button(action: { showSheet = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(width: 30, height: 30)
                        .background(Color.secondary.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Map Mode Options
            HStack(spacing: 12) {
                MapModeButton(
                    title: "Explore",
                    icon: "map.fill",
                    isSelected: mapType == .standard
                ) {
                    mapType = .standard
                }
                
                MapModeButton(
                    title: "Driving",
                    icon: "car.fill",
                    isSelected: mapType == .driving
                ) {
                    mapType = .driving
                }
                
                MapModeButton(
                    title: "Transit",
                    icon: "tram.fill",
                    isSelected: mapType == .transit
                ) {
                    mapType = .transit
                }
                
                MapModeButton(
                    title: "Satellite",
                    icon: "globe.americas.fill",
                    isSelected: mapType == .satellite
                ) {
                    mapType = .satellite
                }
            }
            .padding(.horizontal, 20)
            
            // Attribution
            Text("© OpenStreetMap and other data providers")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
        }
    }
}

struct MapModeButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                // Icon container - transparent background
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .frame(height: 70)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(isSelected ? .blue : .primary)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                )
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .blue : .primary)
            }
        }
        .buttonStyle(.plain)
    }
}

enum MapType {
    case standard
    case driving
    case transit
    case satellite
}
