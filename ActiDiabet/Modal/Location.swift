//
//  Location.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 26/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation
import MapKit

enum LocationType{
    case space
    case pool
}

class OpenSpaces: NSObject, MKAnnotation {
    ///This class is for geneating an Annotation for mapview. Based on openspaces data.
    var type: LocationType
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    //  init by json
    init?(json: [String: Any], type: LocationType) {
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
        self.title = name
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.type = type
    }
    
    // configure the annotation to MKPinAnnotationView
    func configureAnnotation() -> MKPinAnnotationView {
        let annotationView = MKPinAnnotationView(annotation: self, reuseIdentifier: "AnnotationView")
        annotationView.canShowCallout = true
        if self.type == .pool {
            annotationView.pinTintColor = .blue
        }
        return annotationView
    }
}
