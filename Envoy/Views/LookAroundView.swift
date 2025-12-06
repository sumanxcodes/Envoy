import SwiftUI
import MapKit

struct LookAroundView: View {
    let scene: MKLookAroundScene
    @State private var isShowingLookAround = true
    
    var body: some View {
        LookAroundPreview(
            initialScene: scene,
            allowsNavigation: true,
            badgePosition: .bottomTrailing
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            print("DEBUG: LookAroundView appeared with scene: \(scene)")
        }
    }
}
