//
//  MainView.swift
//  AtoDoko
//
//  Created by 藤原輔 on 2023/05/20.
//

import SwiftUI
import MapKit
import CoreLocationUI

extension MKMapItem: Identifiable {
}

struct MainView: View {
//    @ObservedObject var manager: LocationManager
    @ObservedObject var manager = LocationManager()
    @State var trackingMode = MapUserTrackingMode.follow
    @State var address: String = "飲食店"
    @State var subRegion = MKCoordinateRegion(
        center: subCoordinate,
        latitudinalMeters: range,
        longitudinalMeters: range
    )
    
    @State private var places: [MKMapItem] = []
    
    @State var searchView = false
    
    static let range: CLLocationDistance = 1000.0
    static let subCoordinate = CLLocationCoordinate2D(latitude: 39.71927, longitude: 141.13337)
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $subRegion, showsUserLocation: true, annotationItems: places) { place in
                MapMarker(coordinate: place.placemark.coordinate, tint: Color.blue)
            }
//            Map(coordinateRegion: $subRegion, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            VStack {
                TextField("検索", text: $address)
                    .onSubmit {
                        Task {
                            if address != "" {
                                if let plcs = await searchItems(query: address, region: subRegion) {
                                    places = plcs
                                    print(places)
                                }
                            }
                            
//                            if let coordinate = await geocodeAddress(address: address) {
//                                subRegion = MKCoordinateRegion(
//                                    center: coordinate,
//                                    latitudinalMeters: Self.range,
//                                    longitudinalMeters: Self.range)
//                            }
                        }   // Task
                    }   // onSubmit
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                Spacer()
                HStack {
                    Spacer()
                    VStack {
//                        LocationButton(.currentLocation) {
//                            manager.requestAllowOnceLocationPermission()
//                        }
//                        .foregroundColor(.white)
//                        .cornerRadius(25.0)
//                        .labelStyle(.iconOnly)
//                        .symbolVariant(.fill)
//                        .padding(40)
                        SearchButton(searchView: $searchView)
                            .padding()
                    }
                }   // HStack
            }   // VStack
        }   // ZStack
        .fullScreenCover(isPresented: $searchView) {
            SearchView(searchView: $searchView)
        }
    }   // body
}   // MainView

struct SearchView: View {
    @Binding var searchView: Bool
    
    var body: some View {
        NavigationStack {
            Text("search View")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        searchView.toggle()
                    }
                }
            }
        }
    }
}

struct SearchButton: View {
    @Binding var searchView: Bool
    var body: some View {
        Button(action: {
            searchView.toggle()
        }, label: {
            Image(systemName: "magnifyingglass.circle.fill")
                .font(.system(size: 80))
                .clipShape(Circle())
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LocationManager())
    }
}
