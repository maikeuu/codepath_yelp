//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit


class BusinessesViewController: BaseViewController {
    //UIKit Properties
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    //Data Properties
    var businesses: [Business]!
    var filteredData: [Business]!
    var currentSearch = "Food"
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.addTarget(self, action: #selector(self.searchButtonClicked), for: .touchUpInside)
        mapButton.addTarget(self, action: #selector(self.mapButtonClicked), for: .touchUpInside)
        setUpView()
        //initialize a search on start up
        Business.searchWithTerm(term: "Food", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
        })
    }
    
    
    private func setUpView() {
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
    
    func loadMoreData() {
        Business.searchWithTerm(term: currentSearch, sort: nil, categories: [], deals: false) { (businesses: [Business]!, error: Error!) -> Void in
            self.businesses.append(contentsOf: businesses)
            self.filteredData = self.businesses
            //infiniteScrollActivity
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
            self.isMoreDataLoading = false
        }
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? businesses : businesses.filter {  (item: Business) -> Bool in
            //If dataItem matches the searchText, return true to include it
            return item.name!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if navSearchBar.text != "" {
            self.currentSearch = navSearchBar.text!
            Business.searchWithTerm(term: currentSearch, completion: {
                (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
                self.filteredData = businesses
                self.tableView.reloadData()
            })
        }
        searchBar.resignFirstResponder()
    }
    
    @objc func searchButtonClicked(_ sender: UIButton?) {
        if navSearchBar.text != "" {
            self.currentSearch = navSearchBar.text!
            Business.searchWithTerm(term: currentSearch, completion: { 
                (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
                self.filteredData = businesses
                self.tableView.reloadData()
            })
        }
    }

    @objc func mapButtonClicked(_ sender: UIButton?) {
        let mapViewController = MapViewController()
        mapViewController.businesses = self.businesses
        self.navigationController?.pushViewController(mapViewController, animated: true)
        
    }
}

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
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
}

extension BusinessesViewController: UIScrollViewDelegate {
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
}


