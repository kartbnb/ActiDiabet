//
//  MapViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 26/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit
import MapKit
import Mapbox

class MapViewController: UIViewController, DatabaseListener {
    
    ///This view controller is for map page
    
    var db: DatabaseProtocol?
    var mapView: MGLMapView?
    var place: [OpenSpaces] = [OpenSpaces]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        self.db = delegate?.databaseController
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let weatherapi = WeatherAPI()
        db?.addListener(listener: self)
        weatherapi.getCoordinate(mapView: self)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        db?.removeListener(listener: self)
    }
    
    // setup ui
    func setMapView(center: CLLocation) {
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        self.mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView!.setCenter(center.coordinate, zoomLevel: 14, animated: false)
        mapView!.delegate = self
        view.addSubview(mapView!)
        self.mapView?.addAnnotations(place)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - Database Listener
    var listenerType: ListenerType = .map
    
    func getActivities(activities: [Activity]) {
        
    }
    
    func addLocation(place: [OpenSpaces]) {
        self.place = place
    }

}
//MARK: - MapViewDelegate
extension MapViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let annotation = annotation as! OpenSpaces
        annotation.showDirection()
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let annotation = annotation as! OpenSpaces
        return annotation.imageOfAnnotation()
    }
}
