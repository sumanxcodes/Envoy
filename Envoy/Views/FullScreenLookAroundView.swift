import SwiftUI
import MapKit

struct FullScreenLookAroundView: View {
    let coordinate: CLLocationCoordinate2D
    @Environment(\.dismiss) private var dismiss
    @State private var scene: MKLookAroundScene?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            if let scene = scene {
                // Just the Look Around preview, no map
                LookAroundPreview(
                    initialScene: scene,
                    allowsNavigation: true,
                    badgePosition: .bottomTrailing
                )
                .ignoresSafeArea()
            } else if let errorMessage = errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    Button("Close") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else if isLoading {
                ProgressView("Loading Look Around...")
            }
        }
        .task {
            await fetchLookAroundScene()
        }
    }
    
    private func fetchLookAroundScene() async {
        let request = MKLookAroundSceneRequest(coordinate: coordinate)
        do {
            let fetchedScene = try await request.scene
            await MainActor.run {
                if let fetchedScene = fetchedScene {
                    self.scene = fetchedScene
                } else {
                    self.errorMessage = "Look Around is not available at this location."
                }
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load Look Around: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
