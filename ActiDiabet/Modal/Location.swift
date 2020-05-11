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
    case hospital
    case cycling
    case water
    case hoop
    case picnic
    case seat
    case bbq
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
        } else if type == "Open_Space"{
            self.type = .space
        } else if type == "Hospital" {
            self.type = .hospital
        } else {
            if name == "Barbeque" {
                self.type = .bbq
            } else if name == "Bicycle Rails" {
                self.type = .cycling
            } else if name == "Drinking Fountain"{
                self.type = .water
            } else if name == "Hoop" {
                self.type = .hoop
            } else if name == "Picnic Setting" {
                self.type = .picnic
            } else {
                self.type = .seat
            }
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
        let park = UIImage(named: "map-park")!
        let pool = UIImage(named: "map-swimming")!
        let seat = UIImage(named: "map-seat")!
        let hospital = UIImage(named: "map-hospital")!
        let bicycle = UIImage(named: "map-bike_rail")!
        let water = UIImage(named: "map-water")!
        let hoop = UIImage(named: "map-hoop")!
        let picnic = UIImage(named: "map-picnic")!
        let bbq = UIImage(named: "map-bbq")!
        switch self.type {
        case .pool:
            return MGLAnnotationImage(image: pool, reuseIdentifier: "pool")
        case .space:
            return MGLAnnotationImage(image: park, reuseIdentifier: "park")
        case .cycling:
            return MGLAnnotationImage(image: bicycle, reuseIdentifier: "bicycle")
        case .water:
            return MGLAnnotationImage(image: water, reuseIdentifier: "water")
        case .hospital:
            return MGLAnnotationImage(image: hospital, reuseIdentifier: "hospital")
        case .bbq:
            return MGLAnnotationImage(image: bbq, reuseIdentifier: "bbq")
        case .seat:
            return MGLAnnotationImage(image: seat, reuseIdentifier: "seat")
        case .hoop:
            return MGLAnnotationImage(image: hoop, reuseIdentifier: "hoop")
        case .picnic:
            return MGLAnnotationImage(image: picnic, reuseIdentifier: "picnic")
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
