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
    var allPlaces: [OpenSpaces] = [OpenSpaces]()
    
    var filter:Set<LocationType> = [.hospital, .space, .pool]
    
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
        mapView!.setCenter(center.coordinate, zoomLevel: 13, animated: false)
        mapView!.delegate = self
        view.addSubview(mapView!)
        setFilter()
        resetAnnotation()
    }
    
    // reset annotation when filter change
    func resetAnnotation() {
        
        if let annotations = mapView?.annotations {
            mapView?.removeAnnotations(annotations) // remove all annotations
        }
        mapView?.addAnnotations(self.getShowingPlaces())  // add new annotations
    }
    
    // set filter ui
    func setFilter() {
        
        let allfilter: [LocationType] = [.bbq, .cycling, .hoop, .hospital, .picnic, .pool, .seat, .space, .water]  // all filters
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let notch = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 // get status bar height
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: notch + view.frame.height - 100, width: view.frame.width, height: 50)) // set scrollview use frame
        
        scrollView.contentSize = CGSize(width: 50 * 9 + 100, height: 50) // set content frame (width: 9 filter and 10px insets)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        for i in 0...8 {
            let infilter: Bool = filter.contains(allfilter[i])
            // set a type of location in each filter
            let filter = FilterView(frame: CGRect(x: 10 + i * 50 + i * 10, y: 0, width: 50, height: 50), type: allfilter[i], inFilter: infilter)
            filter.backgroundColor = .white
            filter.filterDelegate = self
            scrollView.addSubview(filter)
        }
        view.addSubview(scrollView)
    }
    
    // get locations within this filter
    func getShowingPlaces() -> [OpenSpaces] {
        var showingPlaces:[OpenSpaces] = []
        for place in allPlaces {
            if filter.contains(place.type) {
                showingPlaces.append(place)
            }
        }
        return showingPlaces
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
        self.allPlaces = place
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

//MARK: - Filter delegate
extension MapViewController: FilterDelegate {
    // changing filter, update map
    func changeFilter(type: LocationType) {
        if self.filter.contains(type) {
            self.filter.remove(type)
        } else {
            self.filter.insert(type)
        }
        self.resetAnnotation()
        print("current filter: \(filter)")
    }
}
