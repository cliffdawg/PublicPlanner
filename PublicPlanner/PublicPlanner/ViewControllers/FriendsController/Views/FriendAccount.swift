//
//  FriendAccount.swift
//  Public Planner
//
//  Created by Clifford Yin on 1/2/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit
import Firebase

protocol FriendAccountDelegate {
    func showAlert()
}

/* This code constitutes the "friend" account entity */
class FriendAccount: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var friendLabel: UILabel!
    var delegate: FriendAccountDelegate!
    @IBOutlet weak var id: UILabel!
    var ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    @IBOutlet weak var blocker: UISwitch!
    var friendBlocked = false
    @IBOutlet weak var blockLabel: UILabel!
    
    // Blocks those on "block" list
    @IBAction func blocking(_ sender: UISwitch) {
        if sender.isOn == false {
            
            ref.child("users").child(userID!).child("blocked").observe(.value, with: { (snapshot) -> Void in
            for item in snapshot.children {
                
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let blockValue = childSnapshot.value as? NSDictionary
                let blocks = blockValue?["username"] as! String
                
                if blocks == self.friendLabel.text{
                    (item as AnyObject).ref.removeValue()
                    }
                }
            })
        }
        if sender.isOn == true{
        ref.child("users").child(userID!).child("blocked").child(id.text!).setValue(["username": friendLabel.text])}
    }
    
    
    @IBAction func openAlert(_ sender: Any) {
        
        if friendBlocked == true {
            delegate.showAlert()
        
        }
    }
    
    @IBOutlet weak var transit: UIButton!
 
    // Implements if this friend is blocked or not
    func configure4(_ req: String?, aqw: String?){
        friendLabel.text = req
        id.text = aqw
    
        ref.child("users").child(userID!).child("blocked").observe(.value, with: { (snapshot) -> Void in
            for item in snapshot.children {
                
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let blockValue = childSnapshot.value as? NSDictionary
                let blocks = blockValue?["username"] as! String
                
                if blocks == self.friendLabel.text{
                    self.blocker.isOn = true
                }
            }
        })
    
        ref.child("users").child(id.text!).child("blocked").observe(.value, with: { (snapshot) -> Void in
            for item in snapshot.children {
    
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let blockValue = childSnapshot.key
                if blockValue == self.userID{
                    self.friendBlocked = true
                }
            }
        })
        blocker.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    
    }
}
