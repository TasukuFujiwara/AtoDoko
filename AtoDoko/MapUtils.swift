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
