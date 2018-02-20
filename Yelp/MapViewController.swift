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



class MapViewController: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        mapView.showsUserLocation = true
        view.addSubview(mapView)
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
            let defaultLocation = CLLocation.init(latitude: 32.842674, longitude: -117.257767)
            goToLocation(location: defaultLocation)
        }
        addAnnotations()
    
    }
    
    
    @objc func listButtonClicked(_ sender: UIButton?) {
        self.navigationController?.popViewController(animated: false)
    }
    

}
