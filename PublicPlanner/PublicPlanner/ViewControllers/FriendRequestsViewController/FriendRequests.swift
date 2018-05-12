//
//  FriendRequests.swift
//  Public Planner
//
//  Created by Clifford Yin on 12/31/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import UIKit
import CoreData
import Firebase

/* Controller that handles the requests for friends from other users */
class FriendRequests: UIViewController, UITableViewDelegate, UITableViewDataSource, RequestCellDelegate {

    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    var ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    var requestt = [String: String]()
    var currentUser = ""    
    
    // MARK: ViewController overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        load3()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestt.count
    }
    
    // Sets up the requests
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "#3", for: indexPath) as! RequestCell
        
        let nameValues = Array(requestt.keys)
        let IDValues = Array(requestt.values)
        let name = nameValues[indexPath.row]
        let ided = IDValues[indexPath.row]
        
        cell3.configure3(name, texted: ided, curr: currentUser)
        cell3.delegate = self
        return cell3
    }
    
    
    // Stores and displays all the requests sent toward the user from potential friends
    func load3() {
        
        ref.child("users").observe(.value) {(snapshot: FIRDataSnapshot!) in
        
            for item in snapshot.children {
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let infovalue = childSnapshot.value as? NSDictionary
                let IDD = childSnapshot.key
                let info = infovalue?["username"] as? String
                
                if IDD == self.userID{
                    self.currentUser = info!
                }
            }
        
        }
        
        ref.child("users").child(userID!).child("pending").observe(.value) { (snapshot: FIRDataSnapshot!) in
            
            var newItems = [String: String]()
            for item in snapshot.children {
                
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let infovalue = childSnapshot.value as? NSDictionary
                let IDD = childSnapshot.key
                let info = infovalue?["username"] as? String

                newItems[info!] = IDD

            }
        
            self.requestt = newItems
            self.tableView.reloadData()
        }
    }


    func showAlert(){

        let alertController = UIAlertController(title: "Friend added!", message:
            nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

}


