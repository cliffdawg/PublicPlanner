//
//  Loading.swift
//  Public Planner
//
//  Created by Clifford Yin on 1/5/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import Foundation

import UIKit
import CoreData
import ChameleonFramework

/* Code to handle directing of pages in Public Planner transitions */
class Loading: UIViewController {

    var started = false

    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(Loading.checkLogin), with: self, afterDelay: 1) // Do view setup here.

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getToHome()
    }
    
    // Checks to see if user is logged in; if not, bring them to the register page
    @objc func 
    checkLogin() {
        if LoginManager.sharedInstance.isLoggedIn == false {
            
            if started == false {
                let login = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController")
                started = true
                present(login!, animated: true, completion: nil)
                
            }
        }
    }
    
    // Send to home controller
    func getToHome(){
        if LoginManager.sharedInstance.isLoggedIn == true {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.present(secondViewController, animated: true) }
    }
    
    // Send to login controller
    func getToLog(){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(secondViewController, animated: true)
        
    }
    
    // Send to register controller
    func getToRegister(){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(secondViewController, animated: true)
        
    }
}
