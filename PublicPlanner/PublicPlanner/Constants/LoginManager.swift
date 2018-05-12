//
//  LoginManager.swift
//  Public Planner
//
//  Created by Clifford Yin on 8/20/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import Foundation
import Firebase

/* This is a static structure that records login status */
class LoginManager {
    
    var isLoggedIn = false
    var ref = FIRDatabase.database().reference()
    
    func loginWithUsername(_ username:String, password: String) -> Bool {
        if username != "" && password != "" {
            isLoggedIn = true
            return true
        } else {
            isLoggedIn = false
            return false
        }
        }
    
    static let sharedInstance = LoginManager()
    
    fileprivate init () {
       
    }
    
}
