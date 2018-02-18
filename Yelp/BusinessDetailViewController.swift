//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Mike Lin on 2/17/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BusinessDetailViewController: BaseViewController {
    
    var mapView = MKMapView()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = label.font.withSize(25)
        return label
    }()
    
    let reviewsCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = label.font.withSize(11)
        label.textColor = UIColor.black
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        return label
    }()
    
    let categoriesLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(11)
        label.textColor = UIColor.black
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(11)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name!
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            //done in the case that network is too slow to retrieve pictures
            //will find better fix in the future
            if business.imageURL != nil {
                thumbImageView.setImageWith(business.imageURL!)
            }
            categoriesLabel.text = business.categories
            ratingImageView.setImageWith(business.ratingImageURL!)
            distanceLabel.text = business.distance
            priceLabel.text = "$$"
        }
    }
    
    private func setUpView() {
        let margins = view.layoutMarginsGuide
        nameLabel.anchor(top: margins.topAnchor, leading: margins.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        nameLabel.numberOfLines = 0
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        ratingImageView.anchor(top: nameLabel.bottomAnchor, leading: margins.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        reviewsCountLabel.anchor(top: nameLabel.bottomAnchor, leading: ratingImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2, left: 4, bottom: 0, right: 0))
        
        categoriesLabel.anchor(top: ratingImageView.bottomAnchor, leading: margins.leadingAnchor
            , bottom: nil, trailing: nil, padding: .init(top: 2, left: 0, bottom: 0, right: 0))
        
        distanceLabel.anchor(top: margins.topAnchor, leading: nil, bottom: nil, trailing: margins.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        distanceLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor)
        distanceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        distanceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        priceLabel.anchor(top: distanceLabel.bottomAnchor, leading: nil, bottom: nil, trailing: margins.trailingAnchor, padding: .init(top: 2, left: 0, bottom: 0, right: 0))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        mapView = MKMapView()
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        
        mapView.anchor(top: categoriesLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 25, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.size.width, height: 150))
        
        addAnnotationAtAddress(address: business.address!, title: business.name!)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = nil
        view.backgroundColor = .white
        
        [nameLabel, reviewsCountLabel, addressLabel, categoriesLabel, thumbImageView, ratingImageView,
         distanceLabel, priceLabel].forEach{view.addSubview($0)}
         setUpView()
        
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

    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
}
