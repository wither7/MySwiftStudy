//
//  ContentView.swift
//  PathTracking
//
//  Created by 袁新杰 on 2021/11/15.
//
import Foundation
import SwiftUI
import MapKit

//var locationController : LocationController = LocationController()

 var mapViewModel =  MapViewModel()

struct ContentView: View {
    var body: some View {
        MapView()
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
                print("moving to background")
                mapViewModel.changeToBackground()
            })
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
                print("moving to foreground")
                mapViewModel.changeToForeground()
            })
    }
    
}



struct MapView: UIViewRepresentable
{
    @ObservedObject var mapVM = mapViewModel
    typealias UIViewType = MKMapView
    func makeCoordinator() -> MapView.Coordinator {
        return MapView.Coordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = mapVM.mapView
        map.delegate = context.coordinator
        map.showsUserLocation = true
//        if( mapVM.hasLocationPermission() == false)
//        {
            mapVM.locationManager.requestAlwaysAuthorization()
//        }
      
        mapVM.locationManager.startUpdatingLocation()
        

        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {

    }
    
    private func setMapZoomArea(map: MKMapView, polyline: MKPolyline, edgeInsets: UIEdgeInsets, animated: Bool = false) {
          map.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgeInsets, animated: animated)
      }
    class Coordinator: NSObject, MKMapViewDelegate {
//         var control: MapView
//
//         init(_ control: MapView) {
//             self.control = control
//         }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            if let routePolyline = overlay as? MKPolyline {

                let polylineRenderer = MKPolylineRenderer(polyline: routePolyline)
                polylineRenderer.fillColor = UIColor.blue
                polylineRenderer.strokeColor = UIColor.orange
                polylineRenderer.lineWidth = 5
                polylineRenderer.alpha = 1.0
//                polylineRenderer.miterLimit = 3
                
                return polylineRenderer
            }
            return MKOverlayRenderer()
           
        }
        
      
    }
    
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
