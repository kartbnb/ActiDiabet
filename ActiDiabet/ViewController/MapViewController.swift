//
//  MapViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 26/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, DatabaseListener {
    
    ///This view controller is for map page
    
    var db: DatabaseProtocol?
    @IBOutlet weak var mapView: MKMapView!
    
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
        mapView.mapType = .standard
        mapView.delegate = self
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let initailregion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        mapView.setRegion(initailregion, animated: true)
        
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
        for pl in place {
            self.mapView.addAnnotation(pl)
        }
    }

}
//MARK: - MapViewDelegate
extension MapViewController: MKMapViewDelegate {
    // generate custom AnnotationView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? OpenSpaces else { return nil }
        return annotation.configureAnnotation()
    }
}
