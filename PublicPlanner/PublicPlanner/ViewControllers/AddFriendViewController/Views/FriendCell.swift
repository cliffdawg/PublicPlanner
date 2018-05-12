//
//  FriendCell.swift
//  Public Planner
//
//  Created by Clifford Yin on 12/30/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import UIKit
import Firebase

protocol FriendCellDelegate {
    func showAlert()
}

/* Code that represents a friend of the user */
class FriendCell: UITableViewCell{
    
    // MARK: Properties
    
    @IBOutlet weak var userIDD: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    var ref = FIRDatabase.database().reference()
    var delegate: FriendCellDelegate!
    var myself = ""
    
    @IBAction func adding(_ sender: AnyObject) {
        let userIDed = FIRAuth.auth()?.currentUser?.uid
       
        self.ref.child("users").child(userIDD.text!).child("pending").child(userIDed!).setValue(["username": myself]) // Adds this friend to the user's pending requests list
        
        self.ref.child("users").child(userIDed!).child("notAdding").child(userIDD.text!).setValue(["username": userLabel.text!])
        
        delegate.showAlert()
    }
    
    func configure2(_ name: String?, userIDDD: String?, USE: String?) {
        userLabel.text = name
        userIDD.text = userIDDD
        myself = USE!
        }
    }

