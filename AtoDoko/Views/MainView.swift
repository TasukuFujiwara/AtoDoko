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
    @State var query: String = ""
    @State var region = MyMap.region
    
    @State private var mapItems: [MKMapItem] = []
    @State private var routes: [MKRoute] = []
    
    @State var searchView = false
    
    static let range: CLLocationDistance = 1000.0
    static let subCoordinate = CLLocationCoordinate2D(latitude: 39.71927, longitude: 141.13337)
    
    var body: some View {
        ZStack {
            MyMapView(routes: routes)
                .edgesIgnoringSafeArea(.all)

            VStack {
                TextField("", text: $query)
                    .onSubmit {
                        Task {
                            if query != "" {
                                if let items = await searchItems(query: query, region: region) {
                                    mapItems = items
                                }
                                routes = await searchMultiRoute(items: mapItems)
                            }   // if query != ""
                        }   // Task
                    }   // .onSubmit
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                Spacer()
                HStack {
                    Spacer()
                    VStack {                        
                        LocationButton(.currentLocation) {
                            manager.requestAllowOnceLocationPermission()
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 35))
                        .clipShape(Circle())
                        .labelStyle(.iconOnly)
                        .symbolVariant(.fill)
                        .padding()
                        
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
        ZStack {
            Circle()
                .foregroundColor(.blue)
                .frame(width: 75.0)
            Button(action: {
                searchView.toggle()
            }, label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
                    .clipShape(Circle())
        })
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LocationManager())
    }
}
