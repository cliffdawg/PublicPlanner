//
//  FriendsController.swift
//  Public Planner
//
//  Created by Clifford Yin on 12/30/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import UIKit
import CoreData
import Firebase

/* Code to manage the user's added friends */
class FriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource, FriendAccountDelegate {

    @IBOutlet weak var friendsTable: UITableView!
    
    // MARK: Properties
    
    var saveText = ""
    var IDDetail = [String: String]()
    var ref3 = FIRDatabase.database().reference()
    var oneSelect = true
    var friends = [NSManagedObject]()
    var blocked = false
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

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
            load2()
        }
    
    
    // MARK: tableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    // Sets up the cells to represent user's friends
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let frond = tableView.dequeueReusableCell(withIdentifier: "#4", for: indexPath) as! FriendAccount
        let fronded = friends[indexPath.row]
        let nameText = fronded.value(forKey: "username") as? String
        let idtext = fronded.value(forKey: "userID") as? String
        frond.configure4(nameText, aqw: idtext)
        IDDetail[nameText!] = fronded.value(forKey: "userID") as? String
        frond.delegate = self
        if oneSelect == false {frond.transit.setTitle("", for: UIControlState())
            frond.blocker.isHidden = true
            frond.blockLabel.text = ""
        }
        frond.blocker.isHidden = true
        return frond
    }

    
    // Upon selecting a friend cell, it displays the options of blocking/unblocking them
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(IDDetail)
        self.blocked = false
        let cell = self.friendsTable.cellForRow(at: indexPath) as! FriendAccount
        cell.contentView.backgroundColor = UIColor(red: 1, green: 0.659, blue: 0.094, alpha: 0.7)
        let savedText = cell.friendLabel.text
        self.saveText = IDDetail[savedText!]!
        cell.blocker.isHidden = false
        cell.transit.setTitle("Schedule", for: UIControlState())
        cell.blockLabel.text = "Block"
        let idd = cell.id.text
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref3.child("users").child(idd!).child("blocked").observe(.value, with: { (snapshot) -> Void in
            for item in snapshot.children {
                // This utilizes a "blocked" data structure in Firebase to track friends, blocked friends, and their relation to each other
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let blocks = childSnapshot.key
                if blocks == userID {
                    self.blocked = true
                }
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.friendsTable.cellForRow(at: indexPath)! as! FriendAccount
        cell.blocker.isHidden = true
        cell.transit.setTitle("", for: UIControlState())
        cell.blockLabel.text = ""
        }


    // Pulls friend data from Firebase and sets it up as core data
    func load2(){
        let userID = FIRAuth.auth()?.currentUser?.uid
    
        ref3.child("users").child(userID!).child("friends").observe(.value) { (snapshot: FIRDataSnapshot!) in
        
            let appDelegate3 = UIApplication.shared.delegate as! AppDelegate
        
            let managedContext3 = appDelegate3.managedObjectContext
            let entity2 =  NSEntityDescription.entity(forEntityName: "Friend", in:managedContext3)
            var newItems = [NSManagedObject]()
        
            for item in snapshot.children {
                let adding3 = NSManagedObject(entity: entity2!, insertInto: managedContext3)
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let friendValue = childSnapshot.value as? NSDictionary
                let friendName = friendValue?["username"] as? String
                let userIDED = childSnapshot.key
            
                adding3.setValue(friendName, forKey: "username")
                adding3.setValue(userIDED, forKey: "userID")
                newItems.append(adding3)
            }
            self.friends = newItems
            self.friendsTable.reloadData()
        }
    }

    // If a friend has blocked you, Public Planner will notify you upon trying to view their schedule
    func showAlert(){
        let alertController = UIAlertController(title: "Schedule blocked", message:
            "This user has blocked you from seeing their schedule.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Navigation functions
    
    // Cancels segue if you are blocked
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "toEvents" {
                if blocked == true {
                    return false
                }
            }
        }
        return true
    }
    
    // Handles several segues to other controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRequests" {
            
        }

        if segue.identifier == "toEvents" {
            let svc = segue.destination as! FriendsEvents
        
            svc.openID = saveText
        }
    
        if segue.identifier == "toAdd" {
            let svc = segue.destination as! AddFriend
            svc.load5()
        }
    }
}

