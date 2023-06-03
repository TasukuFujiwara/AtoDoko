//
//  LocationManager.swift
//  AtoDoko
//
//  Created by 藤原輔 on 2023/05/21.
//

import MapKit
import Dispatch

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion()
    
    override init() {
        super.init()    // スーパークラスのイニシャライザを実行
        manager.delegate = self     // 自身をデリゲートプロパティに設定
        manager.requestWhenInUseAuthorization()     // 位置情報の利用許可をリクエスト
        manager.desiredAccuracy = kCLLocationAccuracyBest       // 最高精度の位置情報を要求
        manager.distanceFilter = 3.0        // 更新距離(m)
    }
    
    func requestAllowOnceLocationPermission() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(
                center: latestLocation.coordinate,
                latitudinalMeters: 1000.0,
                longitudinalMeters: 1000.0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}