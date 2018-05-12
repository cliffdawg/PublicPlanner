//
//  HomeViewController.swift
//  Public Planner
//
//  Created by Clifford Yin on 8/20/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import ChameleonFramework

/* Code that manages the home view of the login stage of Public Planner */
class HomeViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var scheduleButton: UIButton!
    
    @IBOutlet weak var friendsButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: ViewController overrides
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleButton.layer.cornerRadius = 10
        friendsButton.layer.cornerRadius = 10
        logoutButton.layer.cornerRadius = 10
        self.hideKeyboardWhenTappedAround()
        perform(#selector(HomeViewController.checkLogin), with: self, afterDelay: 1) // Do view setup here.
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        // Implement Chameleon for graphics
        let colors:[UIColor] = [
            UIColor.white,
            UIColor.yellow
            
        ]
        scheduleButton.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: scheduleButton.frame, colors: colors)
        friendsButton.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: friendsButton.frame, colors: colors)
        logoutButton.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: logoutButton.frame, colors: colors)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        
        do { try firebaseAuth?.signOut()
            
            let login = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            present(login!, animated: true, completion: nil)
            LoginManager.sharedInstance.isLoggedIn = false

        } catch {
            
        }
    }
    
    @objc func
    checkLogin() {
        if LoginManager.sharedInstance.isLoggedIn == false {
            //Show the login View
            let login = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController")
            present(login!, animated: true, completion: nil)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTableLoad" {
        
            let destinationNavigationController = segue.destination as! UINavigationController
            let stl = destinationNavigationController.topViewController as! ViewController
            stl.load()
    
        }
    }
    
}
