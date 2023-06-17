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
    
    @State var displayMenu = false
    @State var displayList = false
    
    static let range: CLLocationDistance = 1000.0
    static let subCoordinate = CLLocationCoordinate2D(latitude: 39.71927, longitude: 141.13337)
    
    var body: some View {
        NavigationStack {
            ZStack {
                MyMapView(routes: routes)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        TextField("検索", text: $query)
                            .onSubmit {
                                Task {
                                    if query != "" {
                                        if let items = await searchItems(query: query, region: region) {
                                            mapItems = items
                                        }
                                    }   // if query != ""
                                }   // Task
                                displayList = true
                            }   // .onSubmit
                            .padding()
                            .textInputAutocapitalization(.never)
                            .background(.white)
                            .cornerRadius(40.0)
                            .padding(.horizontal, 60)
                            .offset(x: !displayMenu ? 0 : -30.0, y: !displayMenu ? 0 : -60.0)
                            .scaleEffect(!displayMenu ? 0 : 1.0, anchor: .bottomTrailing)
                        
                        HStack {
                            Spacer()
                            ZStack {
                                LocationButton(.currentLocation) {
                                    manager.requestAllowOnceLocationPermission()
                                }
                                    .foregroundColor(.white)
                                    .font(.system(size: 35))
                                    .clipShape(Circle())
                                    .labelStyle(.iconOnly)
                                    .symbolVariant(.fill)
                                    .offset(y: !displayMenu ? 0 : -130.0)
                                    .scaleEffect(!displayMenu ? 0 : 1.0, anchor: .bottom)
                                
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 80.0)
                                
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        displayMenu.toggle()
                                    }
                                }, label: {
                                    Image(systemName: "magnifyingglass.circle.fill")
                                        .font(.system(size: 80.0))
                                })
                            }   // ZStack
                        }   // HStack
                    }   // ZStack
                    .padding()
                }   // VStack
            }   // ZStack
            .sheet(isPresented: $displayList) {
                List {
                    ForEach(mapItems, id: \.self) { item in
                        Button(item.name ?? "no Name") {
                            Task {
                                routes = await searchMultiRoute(from: item, items: mapItems.filter({ $0 != item }))
                            }
                            displayList = false
                        }
                    }
                }
                .presentationDetents([.medium, .large])
                .presentationContentInteraction(.scrolls)
                .presentationCornerRadius(40)
            }
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
    @Binding var onMenu: Bool
    @Binding var query: String
    
    var body: some View {
        ZStack {
            TextField("検索", text: $query)
                .padding()
                .textInputAutocapitalization(.never)
                .background(.white)
                .cornerRadius(40.0)
                .padding(.horizontal, 60)
                .offset(x: !onMenu ? 0 : -30.0, y: !onMenu ? 0 : -60.0)
                .scaleEffect(!onMenu ? 0 : 1.0, anchor: .bottomTrailing)
            
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 80.0)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            onMenu.toggle()
                        }
                    }, label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 80.0))
                    })
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LocationManager())
    }
}
