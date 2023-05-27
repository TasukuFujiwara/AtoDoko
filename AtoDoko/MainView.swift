//
//  MainView.swift
//  AtoDoko
//
//  Created by 藤原輔 on 2023/05/20.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MainView: View {
//    @ObservedObject var manager: LocationManager
    @ObservedObject var manager = LocationManager()
    @State var trackingMode = MapUserTrackingMode.follow
    @State var address: String = ""
    @State var subRegion = MKCoordinateRegion(
        center: subCoordinate,
        latitudinalMeters: range,
        longitudinalMeters: range
    )
    
    static let range: CLLocationDistance = 1000.0
    static let subCoordinate = CLLocationCoordinate2D(latitude: 39.71927, longitude: 141.13337)
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $subRegion, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            VStack {
                TextField("検索", text: $address)
                    .onSubmit {
                        Task {
                            if let coordinate = await geocodeAddress(address: address) {
                                subRegion = MKCoordinateRegion(
                                    center: coordinate,
                                    latitudinalMeters: Self.range,
                                    longitudinalMeters: Self.range)
                            }
                        }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                Spacer()
                HStack {
                    Spacer()
                    LocationButton(.currentLocation) {
                        manager.requestAllowOnceLocationPermission()
                    }
                    .foregroundColor(.white)
                    .cornerRadius(25.0)
                    .labelStyle(.iconOnly)
                    //.clipShape(Circle())
                    .symbolVariant(.fill)
                    .padding(50)
                }
                
            }
        }
    }
}

//struct MapView: View {
//    @ObservedObject var manager = LocationManager()
//    @State var trackingMode = MapUserTrackingMode.follow
//    @State var address: String = "盛岡市"
//
////    static var coordinate: CLLocationCoordinate2D
//    static let delta: CLLocationDegrees = 1 / 111
//    static let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
//
//    @State var region = MKCoordinateRegion()
//
//    var body: some View {
//        Map(coordinateRegion: $region)
//            .onAppear {
//                print(address)
//                let coordinate = geocodeAddress(address: address)
//                let range = 1000.0
//                if let coordinate = coordinate {
//                    self.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: range, longitudinalMeters: range)
//                } else {
//                    self.region = manager.region
//                    print("current position")
//                }
//            }
//    }
//}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LocationManager())
    }
}
