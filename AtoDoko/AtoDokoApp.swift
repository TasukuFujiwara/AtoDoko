//
//  AtoDokoApp.swift
//  AtoDoko
//
//  Created by 藤原輔 on 2023/05/20.
//

import SwiftUI
import GooglePlaces


@main
struct AtoDokoApp: App {
    @StateObject private var manager = LocationManager()
    
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(manager)
        }
    }
}
