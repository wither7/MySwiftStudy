//
//  LocationViewModel.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/9.
//


import Foundation
import CoreLocation
import Combine

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

//    //Singleton
    static let locationManager = LocationViewModel()
//
    private let clLocationManager = CLLocationManager()
    
    @Published var locationStatus: CLAuthorizationStatus? // 授权状态
    @Published var lastLocation: CLLocation?              //最后一次定位位置
    @Published var runningLocations: [CLLocation?] = []   //
    @Published var runningSpeed: CLLocationSpeed?         // 速度
    @Published var runningSpeeds: [CLLocationSpeed?] = [] // 配速 ？
    @Published var runningAltitude: CLLocationDistance?   //
    @Published var runningAltitudes: [CLLocationDistance?] = []
    @Published var runningDistances: [CLLocationDistance?] = []
    @Published var runningTotalDistance: CLLocationDistance = 0.0
    @Published var isForeground : Bool = true
    
  //  @EnvironmentObject var settings : SettingsStorage
    
    private override init() {
        super.init()
        clLocationManager.delegate = self
        clLocationManager.distanceFilter = 5
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        clLocationManager.requestWhenInUseAuthorization()
        clLocationManager.requestAlwaysAuthorization()
//        clLocationManager.startUpdatingLocation()  //延迟到开始跑步再开启定位
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    /// APP是否有定位权限
    func hasLocationPermission() -> Bool {
        
        switch self.locationStatus {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default:
            break
        }
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard var location = locations.last else { return }
        if !isLocationOutOfChina(location: location.coordinate){
            //对于中国境内定位做一个转换
            let newLocation  = wgs84togcj02(wgs84CLLocation2D: location.coordinate)
            location = CLLocation(latitude: newLocation.latitude, longitude: newLocation.longitude)
        }
        lastLocation = location
        runningLocations.append(lastLocation)
        runningSpeed = location.speed
        runningAltitude = location.altitude
        runningSpeeds.append(runningSpeed)
        runningAltitudes.append(runningAltitude)
        
        // Add location to array
        let locationsCount = runningLocations.count
        if (locationsCount > 1) {
            let newDistanceInMeters = lastLocation?.distance(from: (runningLocations[locationsCount - 2] ?? lastLocation)!)
            runningDistances.append(newDistanceInMeters)
            runningTotalDistance += newDistanceInMeters ?? 0.0
        }
    }
    
    func startedRunning() {
        // Setup background location checking if authorized
        if locationStatus == .authorizedAlways {
            clLocationManager.pausesLocationUpdatesAutomatically = false
            clLocationManager.allowsBackgroundLocationUpdates = true
        }
        // Clear every location except most recent point
        let locationsCount = runningLocations.count
        if (locationsCount > 1) {
            let locationToKeep = runningLocations[locationsCount - 1]
            runningLocations.removeAll()
            runningLocations.append(locationToKeep)
        }
        // Clear all distances
        runningDistances.removeAll()
        runningSpeeds.removeAll()
        runningAltitudes.removeAll()
        runningTotalDistance = 0.0
    }
    //暂停定位
    func stopLocating(){
        clLocationManager.stopUpdatingLocation()
    }
    
    //开启定位
    func startLocating() {
        clLocationManager.startUpdatingLocation()
    }
    
    func clearLocationArray() {
        runningLocations.removeAll()
        runningDistances.removeAll()
        runningSpeeds.removeAll()
        runningAltitudes.removeAll()
        runningTotalDistance = 0.0
    }
    
    func stopTrackingBackgroundLocation() {
        clLocationManager.pausesLocationUpdatesAutomatically = true
        clLocationManager.allowsBackgroundLocationUpdates = false
    }
    
    func changeToBackground(usingBestLocation : Bool)
    {
        self.isForeground = true
        self.clLocationManager.allowsBackgroundLocationUpdates = true
        self.clLocationManager.desiredAccuracy = usingBestLocation ? kCLLocationAccuracyBest : kCLLocationAccuracyThreeKilometers
        self.clLocationManager.distanceFilter = 10
        
    }
    func changeToForeground()
    {
        self.isForeground = false
        self.clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.clLocationManager.distanceFilter = 5.0
    }
}
