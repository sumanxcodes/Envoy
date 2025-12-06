import Foundation
import MapKit
import CoreLocation
import SwiftUI
import Combine

@MainActor
class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to SF
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var permissionStatus: CLAuthorizationStatus = .notDetermined
    
    // Pin management
    @Published var pins: [MapPin] = []
    @Published var selectedPinCoordinate: CLLocationCoordinate2D?
    
    private let locationManager = CLLocationManager()
    
    @Published var mapType: MapType = .standard
    @Published var lookAroundScene: MKLookAroundScene?
    @Published var isLookAroundPresented = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // locationManager.startUpdatingLocation() // Uncomment to enable location updates
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        permissionStatus = manager.authorizationStatus
        if permissionStatus == .authorizedWhenInUse || permissionStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let isFirstUpdate = userLocation == nil
        userLocation = location.coordinate
        
        if isFirstUpdate {
            centerOnUser()
        }
    }
    
    func centerOnUser() {
        guard let location = userLocation else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
    }
    
    func getLookAroundScene() {
        guard let location = userLocation else {
            print("DEBUG: User location is nil")
            return
        }
        print("DEBUG: Requesting Look Around scene for \(location)")
        
        Task { @MainActor in
            let request = MKLookAroundSceneRequest(coordinate: location)
            do {
                let scene = try await request.scene
                if let scene = scene {
                    print("DEBUG: Look Around scene found")
                    self.lookAroundScene = scene
                    self.isLookAroundPresented = true
                } else {
                    print("DEBUG: Look Around scene is nil (not available)")
                }
            } catch {
                print("DEBUG: Error getting Look Around scene: \(error)")
            }
        }
    }
    
    // MARK: - Pin Management
    func addPin(at coordinate: CLLocationCoordinate2D) {
        let pin = MapPin(coordinate: coordinate, title: "Pin \(pins.count + 1)")
        pins.append(pin)
        print("DEBUG: Added pin at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func removePin(_ pin: MapPin) {
        pins.removeAll { $0.id == pin.id }
        print("DEBUG: Removed pin \(pin.id)")
    }
    
    func selectPin(at coordinate: CLLocationCoordinate2D) {
        selectedPinCoordinate = coordinate
        print("DEBUG: Selected pin at \(coordinate.latitude), \(coordinate.longitude)")
    }
}
