import SwiftUI
import MapKit

// MARK: - Custom Double Icon Button
@available(iOS 26.0, *)
struct DoubleIconButton: View {
    var topIcon: String
    var bottomIcon: String
    var topAction: () -> Void
    var bottomAction: () -> Void

    var body: some View {
        Button(action: {
            // No-op: real actions handled by overlay taps
        }) {
            VStack(spacing: 12) {
                Image(systemName: topIcon)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.vertical, 4)

                Image(systemName: bottomIcon)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.vertical, 4)
            }
            .foregroundColor(.primary)
            .padding(.vertical, 6)
            .padding(.horizontal, 4)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.capsule)
        // Split the hit area into top and bottom halves
        .overlay(
            VStack(spacing: 0) {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        topAction()
                    }

                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        bottomAction()
                    }
            }
        )
        .clipShape(Capsule())
    }
}

struct MapView: View {
    @StateObject @MainActor private var mapViewModel = MapViewModel()
    @State private var showMapSettings = false
    @State private var is3DMode = false
    @State private var showLookAround = false
    var body: some View {
        ZStack(alignment: .top) {
            // Map Layer
            MapViewRepresentable(
                region: $mapViewModel.region,
                showsUserLocation: true,
                mapType: $mapViewModel.mapType,
                is3DMode: $is3DMode,
                pins: $mapViewModel.pins,
                onPinSelected: { coordinate in
                    mapViewModel.selectPin(at: coordinate)
                    showLookAround = true
                },
                onAddPin: { coordinate in
                    mapViewModel.addPin(at: coordinate)
                }
            )
            .ignoresSafeArea()
            .onAppear {
                mapViewModel.requestLocationPermission()
            }
            
            // Floating Controls
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    // Left: Look Around
                    if #available(iOS 26.0, *) {
                        Button(action: {
                            showLookAround = true
                        }) {
                            Image(systemName: "binoculars.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                        .controlSize(.large)
                    }else{
                        Button(action: {
                            showLookAround = true
                        }) {
                            Image(systemName: "binoculars.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primary)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                            
                        }
                    }
                    Spacer()
                    
                    // Right: 2D/3D Toggle and Map Controls
                    VStack(spacing: 12) {
                        // 2D/3D Toggle with Glass Effect
                        if #available(iOS 26.0, *) {
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    is3DMode.toggle()
                                }
                            }) {
                                Text(is3DMode ? "3D" : "2D")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .contentTransition(.numericText())
                            }
                            .buttonStyle(.glass)
                            .buttonBorderShape(.circle)
                            .controlSize(.large)
                        } else {
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    is3DMode.toggle()
                                }
                            }) {
                                Text(is3DMode ? "3D" : "2D")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .background(is3DMode ? Color.green : Color.black.opacity(0.7))
                                    .clipShape(Circle())
                            }
                        }
                        
                        // Map Controls - Custom Double Icon Button
                        if #available(iOS 26.0, *) {
                            DoubleIconButton(
                                topIcon: "tram.fill",
                                bottomIcon: "location",
                                topAction: {
                                    showMapSettings.toggle()
                                },
                                bottomAction: {
                                    mapViewModel.centerOnUser()
                                }
                            )
                        } else {
                            VStack(spacing: 0) {
                                Button(action: {
                                    showMapSettings.toggle()
                                }) {
                                    Image(systemName: "tram.fill")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.primary)
                                        .background(Color.black.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                
                                Button(action: {
                                    mapViewModel.centerOnUser()
                                }) {
                                    Image(systemName: "location")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(AppTheme.tint)
                                        .background(Color.black.opacity(0.7))
                                        .clipShape(Circle())
                                }
                            }
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, AppLayout.padding)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showMapSettings) {
            MapSettingsSheet(mapType: $mapViewModel.mapType, showSheet: $showMapSettings)
                .presentationDetents([.fraction(0.3)])
                .presentationDragIndicator(.visible)
        }
        // Look Around sheet - TEMPORARILY DISABLED DUE TO CRASHES
        // .sheet(isPresented: $mapViewModel.isLookAroundPresented) {
        //     if let scene = mapViewModel.lookAroundScene {
        //         NavigationStack {
        //             LookAroundView(scene: scene)
        //                 .navigationTitle("Look Around")
        //                 .navigationBarTitleDisplayMode(.inline)
        //                 .toolbar {
        //                     ToolbarItem(placement: .navigationBarTrailing) {
        //                         Button("Done") {
        //                             mapViewModel.isLookAroundPresented = false
        .fullScreenCover(isPresented: $showLookAround) {
            if let coordinate = mapViewModel.selectedPinCoordinate ?? mapViewModel.userLocation {
                FullScreenLookAroundView(coordinate: coordinate)
            }
        }
    }
}

#Preview {
    MapView()
}
