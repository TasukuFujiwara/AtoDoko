//
//  SampleLocationSearchView.swift
//  AtoDoko
//
//  Created by 藤原輔 on 2023/06/03.
//

import SwiftUI
import MapKit

struct SampleLocationSearchView: View {
    @State private var query = ""
    @State private var region = MyMap.region
    @State private var mapItems: [MKMapItem] = []

    @State var routes: [MKRoute] = []
    @State var route: MKRoute = MKRoute()
    
    var body: some View {
        ZStack {
//            MyMapView(routes: routes)
//                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TextField("", text: $query)
                    .onSubmit {
                        Task {
                            if query != "" {
                                if let items = await searchItems(query: query, region: region) {
                                    mapItems = items
                                }
//                                routes = await searchMultiRoute(items: mapItems)
                            }   // if query != ""
                        }   // Task
                    }   // .onSubmit
                    .frame(width: 350, height: 40)
                    .background(ignoresSafeAreaEdges: .bottom)
                
                Spacer()
            }   // VStack
        }   // ZStack
    }   // body
}   // SampleLocationSearchView

struct SampleLocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SampleLocationSearchView()
    }
}
