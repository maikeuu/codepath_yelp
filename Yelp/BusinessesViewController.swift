//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{
    
    var businesses: [Business]!
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
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

    
    var filteredData: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize the button to be used to search for new inquirys
        searchButton.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        //initialize navigation bar and searchBar properties
        navSearchBar.delegate = self
        navigationItem.rightBarButtonItem = searchBarButton
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
        
//        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
//            self.businesses = businesses
//            self.filteredData = businesses
//            self.tableView.reloadData()
//        }
//        )
        Business.searchWithTerm(term: "Restaurants", sort: .distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: Error!) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
         }
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
    
    @objc func buttonClicked(_ sender: UIButton?) {
        if navSearchBar.text != "" {
            Business.searchWithTerm(term: navSearchBar.text!, completion: { (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
                self.filteredData = businesses
                self.tableView.reloadData()
            }
            )
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
