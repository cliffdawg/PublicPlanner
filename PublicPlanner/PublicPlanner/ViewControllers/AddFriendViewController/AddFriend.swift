//
//  AddFriend.swift
//  Public Planner
//
//  Created by Clifford Yin on 12/30/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import UIKit
import CoreData
import Firebase

extension AddFriend: UISearchResultsUpdating{
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

/* Manages the controller/search bar for adding friends of a user */
class AddFriend: UIViewController, UITableViewDelegate, UITableViewDataSource, FriendCellDelegate{

    // MARK: Properties
    
    let userID = FIRAuth.auth()?.currentUser?.uid
    @IBOutlet weak var tableView: UITableView!
    var refed = FIRDatabase.database().reference()
    var users = [String]()
    var filteredSearches = [String]()
    var nameId = [String: String]()
    var ref4 = FIRDatabase.database().reference()
    var newItems2 = [String]()
    var currentUser = ""
    var userItems = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: ViewController overrides
    
    override func viewDidLoad() {
        
        // set up the search bar
        searchBarred(searchController)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // check for internet connection
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: tableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredSearches.count
        }
        return users.count
    }
    
    // Instantiates the potential people to add as a friend
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "#2", for: indexPath) as! FriendCell
        
        var names = ""
        
        if searchController.isActive && searchController.searchBar.text != "" {
            names = filteredSearches[indexPath.row]
        } else {
            names = users[indexPath.row]
        }
            let names2 = nameId[names]
        cell.configure2(names, userIDDD: names2, USE: currentUser)
        cell.delegate = self
        
        return cell
    }
    
    func searchBarred(_ searchController: UISearchController) {
        searchController.searchBar.autocapitalizationType = .none
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 150/250, alpha: 1.0)

    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredSearches = users.filter { userz in
            return userz.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    // Loads the potential friends
    func load5() {
        self.ref4.child("users").child(self.userID!).child("notAdding").observe(.value) { (snapshot: FIRDataSnapshot!) in
            
            self.userItems = []
            
            for item2 in snapshot.children{
                let childSnapshot2 = snapshot.childSnapshot(forPath: (item2 as AnyObject).key)
                let infoValue2 = childSnapshot2.value as? NSDictionary
                let info2 = infoValue2?["username"] as! String
                self.userItems.append(info2)
            }
        }
        
        ref4.child("users").queryOrdered(byChild: "username").observe(.value) { (snapshot: FIRDataSnapshot!) in
            
            var newItems = [String]()
            
            for item in snapshot.children {
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let infoValue = childSnapshot.value as? NSDictionary
                let info = infoValue?["username"] as! String
                
                if self.userID != childSnapshot.key
                {
                    newItems.append(info)
                    self.nameId[info] = childSnapshot.key
                } else {
                    
                }
                
                if childSnapshot.key == self.userID{
                    self.currentUser = info
                }
            }
            
            self.newItems2 = newItems
            
            var indexed = [Int]()
            
            for (_, element) in self.userItems.enumerated() {
                for (index2, element2) in newItems.enumerated() {
                    if element == element2{
                        indexed.append(index2)
                    }
                }
                
            }
            
            indexed.sort{$1 < $0}
           
            for index3 in indexed{
                self.newItems2.remove(at: index3)
            }
            self.users = self.newItems2

        }
    }
    
    
    // When request is sent to a potential friend, the user is notified
    func showAlert(){
        
        let alertController = UIAlertController(title: "Request sent!", message:
        nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }

}
