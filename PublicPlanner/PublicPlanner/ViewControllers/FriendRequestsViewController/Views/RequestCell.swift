//
//  RequestCell.swift
//  Public Planner
//
//  Created by Clifford Yin on 12/31/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import UIKit
import Firebase

protocol RequestCellDelegate{
    func showAlert()
}

/* Code that handles the functions of a "request" entity */
class RequestCell: UITableViewCell{
    
    // MARK: Properties
    
    var ref = FIRDatabase.database().reference()
    var delegate: RequestCellDelegate!
    @IBOutlet weak var labeled: UILabel!
    var current = ""
    @IBOutlet weak var labeled2: UILabel!
    
    // Function for when the user decides to send a request to a potential friend
    @IBAction func addFriend(_ sender: AnyObject) {
        let userIDD = FIRAuth.auth()?.currentUser?.uid
            // Functions for handling the interaction of the request with the Firebase structures and lists
        self.ref.child("users").child(userIDD!).child("friends").child(labeled2.text!).setValue(["username": labeled.text])
        self.ref.child("users").child(labeled2.text!).child("friends").child(userIDD!).setValue(["username": current])
        self.ref.child("users").child(userIDD!).child("notAdding").child(labeled2.text!).setValue(["username": labeled.text])
        self.ref.child("users").child(labeled2.text!).child("notAdding").child(userIDD!).setValue(["username": current])
        
            delegate.showAlert()
    
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).child("pending").observe(.value, with: { (snapshot) -> Void in
            for item in snapshot.children {
                
                
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let userID = childSnapshot.key
            
                if userID == self.labeled2.text{

                    (item as AnyObject).ref.removeValue()
                    
                }
            }
        })
    }
    
    func configure3(_ text2: String?, texted: String?, curr: String?) {
        labeled.text = text2
        labeled2.text = texted
        self.current = curr!
        
    }
}

