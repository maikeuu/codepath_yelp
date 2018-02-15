//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,
    UIScrollViewDelegate
{
    //Class Properties
    var businesses: [Business]!
    var filteredData: [Business]!
    var currentSearch: String = "Food"
    var isMoreDataLoading = false
    var tableView: UITableView!
    var searchBar: UISearchBar!
    var mapViewController: UIViewController?
    var loadingMoreView: InfiniteScrollActivityView?
    
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
    
    //create and initialize searchBar to be placed onto navigation bar
    let navSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Restaurants"
        searchBar.tintColor = UIColor.lightGray
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        //initialize a search on start up
        Business.searchWithTerm(term: "Food", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
        }
        )
    }
    
    private func setUpView() {
        //initialize the button to be used to search for new inquirys
        searchButton.addTarget(self, action: #selector(self.searchButtonClicked), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        //initialize map button
        mapButton.addTarget(self, action: #selector(self.mapButtonClicked), for: .touchUpInside)
        let mapBarButton = UIBarButtonItem(customView: mapButton)
        
        //initialize navigation bar and searchBar properties
        navSearchBar.delegate = self
        navigationItem.leftBarButtonItem = searchBarButton
        navigationItem.rightBarButtonItem = mapBarButton
        navigationItem.titleView = navSearchBar
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.82, green: 0.13, blue: 0.13, alpha: 1.0)
        
        //initialize tableView onto view
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let tableWidth: CGFloat = self.view.frame.width
        let tableHeight: CGFloat = self.view.frame.height
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: tableWidth, height: tableHeight - barHeight))
        tableView.register(BusinessCell.self, forCellReuseIdentifier: "BusinessCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        
        //initialize infiniteScrollActivityView
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return filteredData!.count
        } else {return 0}
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        //DO NOT UNDER ANY CIRCUMSTANCES SWITCH THE ORDERING OF CELLROW AND BUSINESS
        cell.cellRow = indexPath.row + 1
        cell.business = filteredData[indexPath.row]
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? businesses : businesses.filter {  (item: Business) -> Bool in
            //If dataItem matches the searchText, return true to include it
            return item.name!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    @objc func searchButtonClicked(_ sender: UIButton?) {
        if navSearchBar.text != "" {
            self.currentSearch = navSearchBar.text!
            Business.searchWithTerm(term: currentSearch, completion: { (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
                self.filteredData = businesses
                self.tableView.reloadData()
            }
            )
        }
    }
    
    @objc func mapButtonClicked(_ sender: UIButton?) {
        mapViewController = MapViewController()
        present(mapViewController!, animated: true, completion: nil)
    }
    
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            let buffer: CGFloat = 240
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > (scrollOffsetThreshold - buffer) && tableView.isDragging) {
                self.isMoreDataLoading = true
                //infiniteScrollActivity
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        Business.searchWithTerm(term: self.currentSearch, sort: nil, categories: [], deals: false) { (businesses: [Business]!, error: Error!) -> Void in
            self.businesses.append(contentsOf: businesses)
            self.filteredData = self.businesses
            //infiniteScrollActivity
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
            self.isMoreDataLoading = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
