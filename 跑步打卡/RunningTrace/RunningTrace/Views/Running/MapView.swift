//
//  MapView.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/9.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

var runningStartted = false

struct MapView: UIViewRepresentable
{
    typealias UIViewType = MKMapView
    
    @StateObject var locationManager = LocationViewModel.locationManager
    @EnvironmentObject var runningState : RunningState
    @EnvironmentObject var settings : SettingsStorage
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        return MapView.Coordinator(self, color: MetricsFormat.convertColourChoiceToUIColor(colour:  settings.storedSettings[0].colourChoiceConverted))
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView(frame: .zero)
        
        map.delegate = context.coordinator
        map.showsUserLocation = true

        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        uiView.showsUserLocation = true
        
        //核心逻辑部分：更新地图并绘制路线
        if(!locationManager.hasLocationPermission()){
            return
        }
        //更新mapview
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(userLatitude)!, CLLocationDegrees(userLongitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
        let region = MKCoordinateRegion(center: location, span: span)
        uiView.setRegion(region, animated: true)
        
        //只有在跑步状态下才绘制跑步路线
        if(runningState.isRunning && settings.storedSettings[0].drawingMap){
            runningStartted = true
            let locationsCount = locationManager.runningLocations.count
            
            if(locationsCount < 2){
                return
            }
            var locationsToRoute : [CLLocationCoordinate2D] = []
            for location in locationManager.runningLocations {
                if (location != nil) {
                    locationsToRoute.append(location!.coordinate)
                }
            }
            if (locationsToRoute.count > 1 && locationsToRoute.count <= locationManager.runningLocations.count) {
                let route = MKPolyline(coordinates: locationsToRoute, count: locationsCount)
                uiView.addOverlay(route)
               
                
            }
        }
        else{
            //
            print("clear")
            if runningStartted {
                //清空地图
                uiView.removeOverlays(uiView.overlays)
                runningStartted.toggle()
            }
        }
            
        
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        @EnvironmentObject var settings : SettingsStorage
        
        var control: MapView
        var color : UIColor
        
        init(_ control: MapView , color : UIColor ) {
            self.control = control
            self.color = color
         }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            if let routePolyline = overlay as? MKPolyline {

                let polylineRenderer = MKPolylineRenderer(polyline: routePolyline)
                polylineRenderer.fillColor = self.color
                polylineRenderer.strokeColor = self.color
                polylineRenderer.lineWidth = 5
                polylineRenderer.alpha = 1.0
                
                return polylineRenderer
            }
            return MKOverlayRenderer()
           
        }
        
      
    }
    
}






struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
