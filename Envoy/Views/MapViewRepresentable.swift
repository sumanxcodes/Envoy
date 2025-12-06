import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var showsUserLocation: Bool = true
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = showsUserLocation
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Only update region if it changed significantly to avoid jitter
        // or if we want to enforce the binding.
        // For now, simple update.
        uiView.setRegion(region, animated: true)
        uiView.showsUserLocation = showsUserLocation
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Update binding back to SwiftUI
            // Use a threshold to prevent infinite loops if needed
            DispatchQueue.main.async {
                self.parent.region = mapView.region
            }
        }
    }
}
