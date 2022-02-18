//
//  LocationController.swift
//  PathTracking
//
//  Created by 袁新杰 on 2021/11/15.
//

import Foundation
import CoreLocation
import MapKit

class MapViewModel : NSObject ,ObservableObject, CLLocationManagerDelegate
{
    @Published var locationManager : CLLocationManager!
   
    @Published var mapView  = MKMapView()
    
    // Region
    @Published var region: MKCoordinateRegion!
    // Based on Location it will set up
    
    // Alert
    @Published var permissionDenied = false
    
    // Map Type
    /*设置地图的类型（mapType）
    case standard :普通地图(默认)
    case satellite : 卫星云图
    case hybrid : 混合地图(卫星云图的基础上加上普通地图)
    @available(iOS 9.0, *)
    case satelliteFlyover ：3D卫星地图 // 做适配
    case hybridFlyover ：3D混合卫星地图(3D卫星地图 + 普通地图) // 做适配
    case mutedStandard :  一种强调开发人员数据的地图显示模式
*/
//    @Published var mapType: MKMapType = .standard
    
    @Published var coordinates : [CLLocationCoordinate2D] = []
    
    @Published var mapActive : Bool = true
    
  
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.distanceFilter = 5.0
        
        mapView = MKMapView()
        let center = CLLocationCoordinate2D(latitude: 13.086, longitude: 80.27)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.region = region
   //     self.mapView.delegate = self
        
    }

    func changeToBackground()
    {
        self.mapActive = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.locationManager.distanceFilter = 500
        
    }
    func changeToForeground()
    {
        self.mapActive = false
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 5.0
    }
    /// 设备是否开启了定位服务
    func hasLocationService() -> Bool {
        
        return CLLocationManager.locationServicesEnabled()
        
    }
    /// APP是否有定位权限
    func hasLocationPermission() -> Bool {
        
        switch locationPermission() {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default:
            break
        }
        return false
    }
    
    /// 定位的权限
    func locationPermission() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            let status: CLAuthorizationStatus = locationManager.authorizationStatus
            print("location authorizationStatus is \(status.rawValue)")
            return status
        } else {
            let status = CLLocationManager.authorizationStatus()
            print("location authorizationStatus is \(status.rawValue)")
            return status
        }
    }
        
    
    //获取权限，在代理‘didChangeAuthorization’中拿到结果
       func requestLocationAuthorizaiton() {
           locationManager.requestAlwaysAuthorization()
           
       }
       //MARK: - 获取位置
       func requestLocation() {
           locationManager.requestLocation()
       }
    
    //定位
    func focusLocation() {
        guard let _ = region else { return }
        
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
   
 
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Checking Permissions
        switch manager.authorizationStatus {
        case .denied:
            // Alert
            permissionDenied.toggle()
        case .notDetermined:
            // Requesting
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            // If Permission Given
            manager.requestLocation()
        default:
            ()
        }
    }
    
    //错误处理
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Error
        print("出错了！！" + error.localizedDescription)
    }
    
    //位置更新代理
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
//        if(coordinates.isEmpty || coordinates.last!.latitude - (locations.last?.coordinate.latitude)! > 1e-6 || coordinates.last!.longitude - locations.last!.coordinate.longitude > 1e-6 ){
            coordinates.append(location.coordinate)
//        }
//        print("latitude: \(location.coordinate.latitude)   longitude:\(location.coordinate.longitude)")
        print(coordinates)
        
        let zoomLevel = 0.02 //设置地图视图的缩放比例
        self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
       
        // 更新地图显示区域
        self.mapView.setRegion(self.region, animated: true)
       
        //绘制路径
        let geodesic = MKPolyline(coordinates: &coordinates, count: coordinates.count)
//        print("mark2")
        self.mapView.addOverlay(geodesic, level: .aboveRoads)
//        print("mark3")
    }
    
    

 
    

}
