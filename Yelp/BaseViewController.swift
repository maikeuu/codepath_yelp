//
//  BaseViewController.swift
//  Yelp
//
//  Created by Mike Lin on 2/15/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController, UISearchBarDelegate {
    
    //create and initialize searchBar to be placed onto navigation bar
    let navSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Restaurants"
        searchBar.tintColor = UIColor.lightGray
        return searchBar
    }()
    
    //create and initialize mapButton to be placed onto navigation bar
    let mapButton: UIButton = {
        let button = UIButton()
        button.setTitle("Map", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(8, 12, 8, 12) //top, left, bottom, right
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    //Data properties
    var businesses, filteredData: [Business]!
    var currentSearch = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        navSearchBar.delegate = self
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = rgbToColor(redVal: 0, greenVal: 128, blueVal: 128, alphaVal: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //if current navigatigation Controller is the root
        if (self.navigationController?.viewControllers.count == 1) {
            //initialize map button
            let mapBarButton = UIBarButtonItem(customView: mapButton)
            //initialize navigation bar and searchBar properties
            navigationItem.rightBarButtonItem = mapBarButton
            navigationItem.titleView = navSearchBar
            
        } else {
            navigationItem.titleView = navSearchBar
        }
    }
    
    func rgbToColor(redVal: CGFloat, greenVal: CGFloat, blueVal: CGFloat, alphaVal: CGFloat) -> UIColor {
        return UIColor(red: redVal/255, green: greenVal/255, blue: blueVal/255, alpha: alphaVal)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}



