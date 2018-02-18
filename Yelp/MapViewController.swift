//
//  MapViewController.swift
//  Yelp
//
//  Created by Mike Lin on 2/15/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: BaseViewController, CLLocationManagerDelegate {
    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    
//    var businesses: [Business] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapView = MKMapView()
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        //37.785771,-122.406165
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 200
        } else {
            let centerLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
            goToLocation(location: centerLocation)
        }
        addAnnotations()
    }
    
    func addAnnotationAtAddress(address: String, title: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address){ (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate!.coordinate
                    annotation.title = title
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    
    func addAnnotations() {
        for business in self.businesses {
            addAnnotationAtAddress(address: business.address!, title: business.name!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    @objc func listButtonClicked(_ sender: UIButton?) {
        self.navigationController?.popViewController(animated: false)
    }
    

}
