//
//  MapView.swift
//  MapSwiftUITest
//
//  Created by César Manuel on 05/10/23.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable{
    typealias UIViewType = MKMapView
    
    @Binding var directions : [String]
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator{
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView{
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        
        //Definition of places:
        
        //Region:
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 20.68, longitude: -105.3), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        mapView.setRegion(region, animated: true)
        
        
        // Origin place:
        
        //PVR Airport:
        
        let coordinate1 = CLLocationCoordinate2D(latitude: 20.6805184, longitude: -105.2545649)
        
        // ITESM GDA:
        
        let coordinate2 = CLLocationCoordinate2D(latitude: 20.7339528, longitude: -103.456944)
        
        //Placemarks:
        
        let p1 = MKPlacemark(coordinate: coordinate1)
        let p2 = MKPlacemark(coordinate: coordinate2)
        
        //Request:
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = coordinate1
        annotation1.title = "PVR Airport"
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = coordinate2
        annotation2.title = "ITESM GDA"
        
        //Directions:
        
        let directions = MKDirections(request: request)
        directions.calculate{ response, error in
            
            guard let route = response?.routes.first else { return}
            
            mapView.addAnnotation(annotation1)
            mapView.addAnnotation(annotation2)
            mapView.addOverlay(route.polyline)
            
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true
            )
            
            self.directions = route.steps.map{$0.instructions}
            
            
        }
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context){
        //Do nothing
    } 
}
