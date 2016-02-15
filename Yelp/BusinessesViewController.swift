//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {

    var businesses: [Business]!
    var filteredData: [Business]!
    @IBOutlet weak var tableView: UITableView!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        // used for scroll height
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        
        Business.searchWithTerm("Thai", offset: 0, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData = self.businesses
            for business in businesses {
                print(business.name!)
//                print(business.address!)
            }
            
            self.tableView.reloadData()
        })
        
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        var searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets



/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let navigationController = segue.destinationViewController as! UINavigationController
        let mapViewController = navigationController.viewControllers.first as! MapViewController
        mapViewController.businesses = businesses

    }

}



extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData != nil {
            return filteredData!.count
        } else {
            return 0
        }
     }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = filteredData[indexPath.row]
        
        return cell
    }

}

extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        if !isMoreDataLoading {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height

            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                
                // Code to load more results
                loadMoreData()

            }
        }
    }
    
    func loadMoreData() {
        print(businesses.count)
        Business.searchWithTerm("Thai", offset: businesses.count, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses.appendContentsOf(businesses)
            self.filteredData = self.businesses
            for business in businesses {
                print(business.name!)
//                print(business.address!)
            }
            
            // Update flag
            self.isMoreDataLoading = false

            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()

            self.tableView.reloadData()
        })
    }

}

extension BusinessesViewController: UISearchBarDelegate {

    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = businesses
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            
            var titleData: [String] = [String]()
            for business in businesses! {
                titleData.append(business.name!)
            }
            filteredData = businesses!.filter({(dataItem: Business) -> Bool in
                // If dataItem's title matches the searchText, return true to include it
                if let title = dataItem.name {
                    if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                        return true
                    } else {
                        return false
                    }
                }
                // If dataItem does not have a title
                return false
            })
        }
        tableView.reloadData()
    }
    
}
