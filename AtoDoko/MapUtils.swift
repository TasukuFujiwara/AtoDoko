//
//  MapUtils.swift
//  AtoDoko
//
//  Created by 藤原輔 on 2023/05/21.
//

import Foundation
import SwiftUI
import MapKit

func geocodeAddress(address: String) async -> CLLocationCoordinate2D? {
    let geocoder = CLGeocoder()
    let coordinate = try? await geocoder.geocodeAddressString(address).first?.location?.coordinate
    return coordinate
}

func searchItems(query: String, region: MKCoordinateRegion) async -> [MKMapItem]? {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = query
    searchRequest.region = region
    
    let search = MKLocalSearch(request: searchRequest)
    let items: [MKMapItem]? = try? await search.start().mapItems
    
    return items
}

func searchRoute(from source: MKMapItem, to destination: MKMapItem) async -> MKRoute? {
    let request = MKDirections.Request()
    
    request.source = source; request.destination = destination
    request.transportType = .walking
    
    let route = try? await MKDirections(request: request).calculate().routes.first
    
    return route
}

func searchMultiRoute(from source: MKMapItem, items: [MKMapItem]) async -> [MKRoute] {
    var routes: [MKRoute] = []
    
    for item in items.shuffled() {
        if let route = await searchRoute(from: source, to: item) {
            routes.append(route)
        }
        if routes.count >= 5 {
            break
        }
    }
    
    return routes
}
