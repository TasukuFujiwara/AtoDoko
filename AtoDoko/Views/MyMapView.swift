//
//  MyMapView.swift
//  AtoDoko
//
//  Created by 藤原輔 on 2023/06/04.
//

import SwiftUI
import MapKit

struct MyMapView: UIViewRepresentable {
    let myMap = MyMap()
    var routes: [MKRoute] = []
    var annotations: [MKAnnotation] = []

    init(annotations: [MKAnnotation], routes: [MKRoute]) {
        self.annotations = annotations
        self.routes = routes.sorted(by: {$0.distance < $1.distance})
    }
    
    func makeUIView(context: Context) -> MKMapView {
        return myMap.map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
        uiView.removeOverlays(uiView.overlays)
        uiView.delegate = myMap

        let multiPolyline = MKMultiPolyline(routes.map({$0.polyline}))
        uiView.addOverlay(multiPolyline, level: .aboveRoads)
        
        if let rect = routes.last?.polyline.boundingMapRect {
            var rectRegion = MKCoordinateRegion(rect)
            rectRegion.span.latitudeDelta *= 1.5
            rectRegion.span.longitudeDelta *= 1.5
            uiView.setRegion(rectRegion, animated: true)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MyMapView(annotations: [], routes: [])
    }
}
