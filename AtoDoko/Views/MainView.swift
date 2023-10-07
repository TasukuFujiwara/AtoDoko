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
    //@ObservedObject var manager: LocationManager
    @ObservedObject var manager = LocationManager()
    @State var trackingMode = MapUserTrackingMode.follow
    @State var query: String = ""
    @State private var region = MyMap.region
    
    @State private var mapItems: [MKMapItem] = []
    @State private var annotations: [MKAnnotation] = []
    @State private var routes: [MKRoute] = []
    
    @State var displayMenu = false
    @State var displayList = false
    
    @State private var leftMode = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                MyMapView(annotations: annotations , routes: routes)
                    .blur(radius: !displayMenu ? 0 : 3.0)
                    .ignoresSafeArea()
                    .disabled(displayMenu)
                
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
                                        annotations = []; routes = []
                                        for item in mapItems {
                                            let annotation = MKPointAnnotation()
                                            annotation.coordinate = item.placemark.coordinate
                                            annotation.title = item.name
                                            annotations.append(annotation)
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
                            .offset(
                                x: !displayMenu ? 0 : !leftMode ? -30.0 : 30.0,
                                y: !displayMenu ? 0 : -60.0
                            )
                            .scaleEffect(
                                !displayMenu ? 0 : 1.0,
                                anchor: !leftMode ? .bottomTrailing : .bottomLeading
                            )
                        
                        HStack {
                            if !leftMode { Spacer() }
                            ZStack {
//                                LocationButton(.currentLocation) {
//                                    manager.requestAllowOnceLocationPermission()
//                                    withAnimation(.easeOut(duration: 0.15)) {
//                                        displayMenu = false
//                                    }
//                                }
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 35))
//                                    .clipShape(Circle())
//                                    .labelStyle(.iconOnly)
//                                    .symbolVariant(.fill)
//                                    .offset(y: !displayMenu ? 0 : -130.0)
//                                    .scaleEffect(!displayMenu ? 0 : 1.0, anchor: .bottom)
                                
                                ZStack {
                                    Circle()
                                        .foregroundColor(.white)
                                        .frame(width: 70.0)
                                    
                                    Button(action: {
                                        leftMode.toggle()
                                    }, label: {
                                        Image(systemName: !leftMode ? "circle.lefthalf.fill" : "circle.righthalf.fill")
                                    })
                                }
                                    .font(.system(size: 80.0))
                                    .offset(
                                        x: !displayMenu ? 0 : !leftMode ? -100.0 : 100.0,
                                        y: !displayMenu ? 0 : 60.0
                                    )
                                    .scaleEffect(
                                        !displayMenu ? 0 : 1.0,
                                        anchor: !leftMode ? .topTrailing : .topLeading
                                    )

                                ZStack {
                                    Circle()
                                        .foregroundColor(.white)
                                        .frame(width: 70.0)
                                    
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.15)) {
                                            displayMenu.toggle()
                                        }
                                    }, label: {
                                        Image(systemName: "magnifyingglass.circle.fill")
                                            .font(.system(size: 80.0))
                                    })
                                }
                            }   // ZStack
                            if leftMode { Spacer() }
                        }   // HStack
                    }   // ZStack
                    .padding(!leftMode ? .trailing : .leading, 10.0)
                    .padding(.bottom, 70.0)
                }   // VStack
            }   // ZStack
            .sheet(isPresented: $displayList) {
                List {                    
                    ForEach(mapItems, id: \.self) { item in
                        HStack {
                            Button(item.name ?? "no Name") {
                                Task {
                                    routes = await searchMultiRoute(from: item, items: mapItems.filter({ $0 != item }))
                                }
                                displayList = false
                                displayMenu = false
                            }
                            Spacer()
                            Text("5km")
                                .foregroundColor(.gray)
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LocationManager())
    }
}
