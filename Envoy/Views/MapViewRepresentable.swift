import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var showsUserLocation: Bool = true
    @Binding var mapType: MapType
    @Binding var is3DMode: Bool
    @Binding var pins: [MapPin]
    var onPinSelected: (CLLocationCoordinate2D) -> Void
    var onAddPin: (CLLocationCoordinate2D) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = showsUserLocation
        
        // Configure dark map appearance
        let config = MKStandardMapConfiguration(emphasisStyle: .muted)
        config.pointOfInterestFilter = .includingAll
        config.showsTraffic = false
        mapView.preferredConfiguration = config
        
        // Enable POI selection
        if #available(iOS 16.0, *) {
            mapView.selectableMapFeatures = [.pointsOfInterest]
        }
        
        // Add long-press gesture to add pins
        let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        mapView.addGestureRecognizer(longPress)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("DEBUG: updateUIView called")
        // Update coordinator parent
        context.coordinator.parent = self
        
        // Update 3D mode first (if changed)
        if context.coordinator.lastIs3DMode != is3DMode {
            context.coordinator.lastIs3DMode = is3DMode
            update3DMode(uiView)
        }
        
        // Only update region if it's a programmatic change (not user panning)
        // Check if region binding changed from last programmatic update
        let shouldUpdateRegion: Bool
        if let lastProgrammatic = context.coordinator.lastProgrammaticRegion {
            let centerDiff = abs(lastProgrammatic.center.latitude - region.center.latitude) + abs(lastProgrammatic.center.longitude - region.center.longitude)
            let spanDiff = abs(lastProgrammatic.span.latitudeDelta - region.span.latitudeDelta) + abs(lastProgrammatic.span.longitudeDelta - region.span.longitudeDelta)
            shouldUpdateRegion = centerDiff > 0.00001 || spanDiff > 0.00001
        } else {
            // First time - update region
            shouldUpdateRegion = true
        }
        
        if shouldUpdateRegion {
            print("DEBUG: Programmatic region change detected, updating map")
            context.coordinator.lastProgrammaticRegion = region
            context.coordinator.isUpdatingRegion = true
            uiView.setRegion(region, animated: true)
        } else {
            print("DEBUG: No programmatic region change, keeping user's pan position")
        }
        
        uiView.showsUserLocation = showsUserLocation
        
        if uiView.mapType != mapTypeToMKMapType(mapType) {
             print("DEBUG: Setting mapType to \(mapType)")
             updateMapType(uiView)
        }
        
        // Update annotations for pins
        updateAnnotations(uiView, context: context)
    }
    
    private func updateAnnotations(_ mapView: MKMapView, context: Context) {
        // Get current pin IDs
        let currentPinIds = Set(pins.map { $0.id })
        
        // Only update if pins actually changed
        guard currentPinIds != context.coordinator.lastPinIds else {
            print("DEBUG: Pins unchanged, skipping annotation update")
            return
        }
        
        print("DEBUG: Pins changed, updating annotations")
        context.coordinator.lastPinIds = currentPinIds
        
        // Get existing pin annotations (not user location)
        let existingAnnotations = mapView.annotations.filter { !($0 is MKUserLocation) } as! [MKPointAnnotation]
        
        // Create a map of existing annotations by coordinate
        var existingByCoordinate: [String: MKPointAnnotation] = [:]
        for annotation in existingAnnotations {
            let key = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
            existingByCoordinate[key] = annotation
        }
        
        // Track which annotations to keep
        var annotationsToKeep: Set<String> = []
        
        // Add or update annotations for current pins
        for pin in pins {
            let key = "\(pin.coordinate.latitude),\(pin.coordinate.longitude)"
            annotationsToKeep.insert(key)
            
            if existingByCoordinate[key] == nil {
                // New pin - add annotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = pin.coordinate
                annotation.title = pin.title
                mapView.addAnnotation(annotation)
                print("DEBUG: Added new annotation at \(key)")
            }
            // Existing pin - keep it (don't remove/re-add to preserve callout)
        }
        
        // Remove annotations that are no longer in pins
        for (key, annotation) in existingByCoordinate {
            if !annotationsToKeep.contains(key) {
                mapView.removeAnnotation(annotation)
                print("DEBUG: Removed annotation at \(key)")
            }
        }
    }
    
    private func update3DMode(_ mapView: MKMapView) {
        let camera = mapView.camera.copy() as! MKMapCamera
        
        if is3DMode {
            // 3D mode: Set pitch to 60 degrees for 3D perspective
            camera.pitch = 60
            camera.altitude = 1000 // Adjust altitude for better 3D view
        } else {
            // 2D mode: Set pitch to 0 for flat view
            camera.pitch = 0
        }
        
        mapView.setCamera(camera, animated: true)
    }
    
    private func mapTypeToMKMapType(_ type: MapType) -> MKMapType {
        switch type {
        case .standard, .driving: return .standard
        case .transit: return .hybrid
        case .satellite: return .satellite
        }
    }
    
    private func updateMapType(_ uiView: MKMapView) {
        switch mapType {
        case .standard:
            uiView.mapType = .standard
            uiView.showsTraffic = false
        case .driving:
            uiView.mapType = .standard
            uiView.showsTraffic = true
        case .transit:
            uiView.mapType = .hybrid
            uiView.showsTraffic = false
        case .satellite:
            uiView.mapType = .satellite
            uiView.showsTraffic = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        var lastIs3DMode: Bool = false
        var isUpdatingRegion: Bool = false
        var lastPinIds: Set<UUID> = []
        var lastProgrammaticRegion: MKCoordinateRegion?
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Don't update binding if we're programmatically setting the region
            guard !isUpdatingRegion else {
                isUpdatingRegion = false
                return
            }
            
            // Don't update region binding to prevent map from jumping back
            // Only update region programmatically (centerOnUser, etc.)
            print("DEBUG: User moved map, NOT updating region binding to prevent jumping")
            
            // REMOVED: This was causing the map to jump back
            // DispatchQueue.main.async {
            //     self.parent.region = mapView.region
            // }
        }
        
        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            guard gesture.state == .began else { return }
            guard let mapView = gesture.view as? MKMapView else { return }
            
            let location = gesture.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            print("DEBUG: Long press at \(coordinate.latitude), \(coordinate.longitude)")
            parent.onAddPin(coordinate)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Don't customize user location
            guard !(annotation is MKUserLocation) else { return nil }
            
            // For regular annotations (pins)
            if annotation is MKPointAnnotation {
                let identifier = "PinAnnotation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                    annotationView?.markerTintColor = .systemRed
                    
                    // Add detail disclosure button to open Look Around
                    let button = UIButton(type: .detailDisclosure)
                    annotationView?.rightCalloutAccessoryView = button
                } else {
                    annotationView?.annotation = annotation
                }
                
                return annotationView
            }
            
            // For POIs (map features)
            return nil // Use default POI rendering
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            // Handle detail button tap - open Look Around
            guard let annotation = view.annotation,
                  !(annotation is MKUserLocation) else { return }
            
            print("DEBUG: Callout button tapped for annotation at \(annotation.coordinate.latitude), \(annotation.coordinate.longitude)")
            parent.onPinSelected(annotation.coordinate)
        }
    }
}
