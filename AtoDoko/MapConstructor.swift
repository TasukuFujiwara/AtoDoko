//
//  MapConstractor.swift
//  AtoDoko
//
//  Created by 藤原輔 on 2023/06/04.
//

import Foundation
import MapKit

class MyMap: NSObject, MKMapViewDelegate {
//    var manager = LocationManager()
    
    let map = MKMapView()
    var config = MKStandardMapConfiguration(elevationStyle: .flat)
    
    static let gandai = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.71927, longitude: 141.13337),
        latitudinalMeters: 1000.0,
        longitudinalMeters: 1000.0
    )
    
    static let tokyo = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.681, longitude: 139.7672),
        latitudinalMeters: 1000.0,
        longitudinalMeters: 1000.0
    )
    
    static let region = tokyo
    
    override init() {
        super.init()
        map.preferredConfiguration = config
        map.delegate = self
        map.selectableMapFeatures = .pointsOfInterest
        map.region = Self.region
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let multiPolyline = overlay as? MKMultiPolyline {
            let renderer = MKMultiPolylineRenderer(multiPolyline: multiPolyline)
            renderer.strokeColor = .systemTeal
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKPolylineRenderer(overlay: overlay)
    }
}
