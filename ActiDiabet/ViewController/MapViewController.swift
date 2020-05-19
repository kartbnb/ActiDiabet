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
    var locationManager: CLLocationManager?
    
    // Default
    var filter:Set<LocationType> = [.hospital, .space]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager?.startUpdatingLocation()
        }
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
        var url: URL?
        if self.isInDaytime(date: Date()) {
            url = URL(string: "mapbox://styles/mapbox/light-v10")
        } else {
            url = URL(string: "mapbox://styles/mapbox/dark-v10")
        }
        self.mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView!.setCenter(center.coordinate, zoomLevel: 13, animated: false)
        mapView?.showsUserLocation = true
        mapView!.delegate = self
        view.addSubview(mapView!)
        setFilter()
        resetAnnotation()
    }
    
    func isInDaytime(date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: date)
        let hour = Int(String(time.split(separator: ":").first!))!
        if hour >= 20 || hour <= 5 {
            return false
        } else {
            return true
        }
    }
    
    // reset annotation when filter change
    private func resetAnnotation() {
        if let annotations = mapView?.annotations {
            mapView?.removeAnnotations(annotations) // remove all annotations
        }
        mapView?.addAnnotations(self.getShowingPlaces())  // add new annotations
    }
    
    // set filter ui
    private func setFilter() {
        let showingFilters = self.showingFilters(locations: allPlaces) // get filters which need to be shown
        let filters = self.findShowingFilters(filter: showingFilters)

        let upperFilter = filters["upper"]! // upper filters
        let lowerFilter = filters["lower"]!  // lower filters
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let notch = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 // get status bar height
        let filterWidth = 100  // FilterView width
        
        let lowerFrame = CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 50)
        let upperFrame = CGRect(x: 0, y: notch + 60, width: view.frame.width, height: 50)
        
        let upperScroll = UIScrollView(frame: upperFrame)
        upperScroll.contentSize = CGSize(width: filterWidth * upperFilter.count + 10 * (upperFilter.count + 1), height: 50)
        upperScroll.contentOffset = CGPoint(x: 0, y: 0)
        upperScroll.isScrollEnabled = true
        upperScroll.showsHorizontalScrollIndicator = false
        for i in 0..<upperFilter.count {
            let infilter: Bool = filter.contains(upperFilter[i])
            // set a type of location in each filter
            let filter = FilterView(frame: CGRect(x: 10 + i * filterWidth + i * 10, y: 0, width: filterWidth, height: 50), type: upperFilter[i], inFilter: infilter)
            filter.backgroundColor = .white
            filter.layer.opacity = 0.8
            filter.filterDelegate = self
            upperScroll.addSubview(filter)
        }
        
        
        let lowerScroll = UIScrollView(frame: lowerFrame) // set scrollview use frame
        lowerScroll.contentSize = CGSize(width: filterWidth * lowerFilter.count + 10 * (lowerFilter.count + 1), height: 50) // set content frame (width: 9 filter and 10px insets)
        lowerScroll.contentOffset = CGPoint(x: 0, y: 0)
        lowerScroll.isScrollEnabled = true
        lowerScroll.showsHorizontalScrollIndicator = false
        for i in 0..<lowerFilter.count {
            let infilter: Bool = filter.contains(lowerFilter[i])
            // set a type of location in each filter
            let filter = FilterView(frame: CGRect(x: 10 + i * filterWidth + i * 10, y: 0, width: filterWidth, height: 50), type: lowerFilter[i], inFilter: infilter)
            filter.backgroundColor = .white
            filter.layer.opacity = 0.8
            filter.filterDelegate = self
            lowerScroll.addSubview(filter)
        }
        view.addSubview(upperScroll)
        view.addSubview(lowerScroll)
    }
    
    private func getUserLocation() {
        let locationManager = CLLocationManager()
        
    }

    private func showingFilters(locations: [OpenSpaces]) -> Set<LocationType> {
        var type:Set<LocationType> = []
        for location in locations {
            if !type.contains(location.type) {
                type.insert(location.type)
            }
        }
        return type
    }

    private func findShowingFilters(filter: Set<LocationType>) -> [String:[LocationType]] {
//        let filterArray = Array(filter)
//        let upperFilter: Set<LocationType> = [.bbq, .picnic, .pool, .cycling, .space, .hoop]
        let result: [String: [LocationType]] = ["upper": [.hospital, .water, .seat, .toilet], "lower": [.space, .bbq, .picnic, .pool, .cycling, .hoop]]
//        for filter in filterArray {
//            if upperFilter.contains(filter) {
//                result["upper"]!.append(filter)
//            }
//        }
        return result
    }
    
    // get locations within this filter
    private func getShowingPlaces() -> [OpenSpaces] {
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

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue = locationManager?.location!.coordinate
        let userLocation = MGLPointAnnotation()
    }
}
