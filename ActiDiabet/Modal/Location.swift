//
//  Location.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 26/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation
import Mapbox
import MapKit

enum LocationType{
    case space
    case pool
}

class OpenSpaces: NSObject, MGLAnnotation {
    ///This class is for geneating an Annotation for mapview. Based on openspaces data.
    var type: LocationType
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    //  init by json
    init?(json: [String: Any]) {
        guard let name = json["place_name"] as? String else {
            print("no place name key")
            return nil
        }
        guard let lat = json["lat"] as? Double else {
            print("no lat key")
            return nil
        }
        guard let lon = json["long"] as? Double else {
            print("no long key")
            return nil
        }
        guard let type = json["place_label"] as? String else {
            print("no label key")
            return nil
        }
        guard let category = json["place_category"] as? String else {
            print("no category key")
            return nil
        }
        self.title = name
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        if type == "Swimming_Pool" {
            self.type = .pool
        } else {
            self.type = .space
        }
        self.subtitle = category
    }
    
    // configure the annotation to MKPinAnnotationView
//    func configureAnnotation() -> MGLCalloutView {
//        let annotationView = MG
//        annotationView.canShowCallout = true
//        if self.type == .pool {
//            annotationView.pinTintColor = .blue
//        }
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//
//        button.setImage(UIImage(systemName: "location.north"), for: .normal)
//        button.addTarget(self, action: #selector(showDirection(_:)), for: .touchUpInside)
//        annotationView.rightCalloutAccessoryView = button
//
//        return annotationView
//    }
    
    func imageOfAnnotation() -> MGLAnnotationImage {
        let park = UIImage(named: "icons8-park")!
        let pool = UIImage(named: "icons8-swimming")!
        switch self.type {
        case .pool:
            return MGLAnnotationImage(image: pool, reuseIdentifier: "pool")
        case .space:
            return MGLAnnotationImage(image: park, reuseIdentifier: "park")
        }
    }
    
    func showDirection() {
        let distance: CLLocationDistance = 1500
        
        //define region span
        let regionSpan = MKCoordinateRegion(center: coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        // define options how map will appear
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        // define name of location
        mapItem.name = self.title
        mapItem.openInMaps(launchOptions: options)
    }
}
