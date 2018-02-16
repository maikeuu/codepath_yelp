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
    
    //create and initialize searchButton to be placed onto navigation bar
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(8, 12, 8, 12) //top, left, bottom, right
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton()
        button.setTitle("List", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(8, 12, 8, 12) //top, left, bottom, right
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        navSearchBar.delegate = self
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.82, green: 0.13, blue: 0.13, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //if current navigatigation Controller is the root
        if (self.navigationController?.viewControllers.count == 1) {
            let searchBarButton = UIBarButtonItem(customView: searchButton)
            //initialize map button
            let mapBarButton = UIBarButtonItem(customView: mapButton)
            //initialize navigation bar and searchBar properties
            navigationItem.leftBarButtonItem = searchBarButton
            navigationItem.rightBarButtonItem = mapBarButton
            navigationItem.titleView = navSearchBar
            
        } else {
            //TODO: figure out how to customize navigation bar in other controllers
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


