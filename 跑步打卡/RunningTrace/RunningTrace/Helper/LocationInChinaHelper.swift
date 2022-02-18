//
//  LocationInChinaHelper.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/23.
//  Thanks to Baiyi

import Foundation
import CoreLocation

func isLocationOutOfChina(location: CLLocationCoordinate2D) -> Bool {

    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271) {
        return true
    } else {
        return false
    }
}

func transformLatWith(x: Double, y: Double) -> Double {
    let π: Double = 3.14159265358979324
    let tempSqrtLat = 0.2 * sqrt(abs(x))
    var lat: Double = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + tempSqrtLat
    lat += (20.0 * sin(6.0 * x * π) + 20.0 * sin(2.0 * x * π)) * 2.0 / 3.0
    lat += (20.0 * sin(y * π) + 40.0 * sin(y / 3.0 * π)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * π) + 320 * sin(y * π / 30.0)) * 2.0 / 3.0;
    return lat
}

func transformLonWith(x: Double, y: Double) -> Double {
    let π: Double = 3.14159265358979324
    let tempSqrtLon = 0.1 * sqrt(abs(x))
    var lon: Double = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + tempSqrtLon
    lon += (20.0 * sin(6.0 * x * π) + 20.0 * sin(2.0 * x * π)) * 2.0 / 3.0
    lon += (20.0 * sin(x * π) + 40.0 * sin(x / 3.0 * π)) * 2.0 / 3.0
    lon += (150.0 * sin(x / 12.0 * π) + 300.0 * sin(x / 30.0 * π)) * 2.0 / 3.0
    return lon
}

func wgs84togcj02(wgs84CLLocation2D: CLLocationCoordinate2D) -> CLLocationCoordinate2D{
    if !isLocationOutOfChina(location: wgs84CLLocation2D) {
                    
        let ee: Double = 0.00669342162296594323
        let a: Double = 6378245.0
        let π: Double = 3.14159265358979324
        
        var dlat: Double = transformLatWith(x: wgs84CLLocation2D.longitude - 105.0, y: wgs84CLLocation2D.latitude - 35.0)
        var dlng: Double = transformLonWith(x: wgs84CLLocation2D.longitude - 105.0, y: wgs84CLLocation2D.latitude - 35.0)
        let radlat: Double = wgs84CLLocation2D.latitude / 180.0 * π
        
        var magic: Double = sin(radlat)
        magic = 1 - ee * magic * magic
        let sqrtmagic: Double = sqrt(magic)
        dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * π)
        dlng = (dlng * 180.0) / (a / sqrtmagic * cos(radlat) * π)
        let mglat: Double = wgs84CLLocation2D.latitude + dlat;
        let mglng: Double = wgs84CLLocation2D.longitude + dlng;
        let GCJ02CLLocation2D: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: mglat, longitude: mglng)
        return GCJ02CLLocation2D
    }
    else {
        return wgs84CLLocation2D
    }
}
