//
//  LoginViewController.swift
//  Public Planner
//
//  Created by Clifford Yin on 8/20/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//


import UIKit
import Firebase
import ChameleonFramework

/* Code that manages the login page of Public Planner */
class LoginViewController: UIViewController {

    var ref = FIRDatabase.database().reference()
    let yellowColor = UIColor.init(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
    let tanColor = UIColor.init(red: 255/255, green: 255/255, blue: 0/255, alpha: 0)
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var textBlock: UILabel!
    
    // Processes the user's attempt to log in
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        FIRAuth.auth()?.signIn(withEmail: usernameText.text!, password: passwordText.text!, completion: {(user, error) in
            if error != nil{
                print(("Unable to sign in user"))
                
                let alertController = UIAlertController(title: "Unable to sign in user", message:
                    nil, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                let uid = FIRAuth.auth()?.currentUser!.uid
                print(("Login successful with user ID: \(uid)"))
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "loadingController") as! Loading
                self.present(secondViewController, animated: true)
            }
        
            if LoginManager.sharedInstance.loginWithUsername(self.usernameText.text!, password: self.passwordText.text!){
                LoginManager.sharedInstance.isLoggedIn = true
       
                }
            })
    }
    
    // Processes the user's attempt to register and sends them to the register page
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(secondViewController, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        
        }
        // Implements the Chameleon framework for graphics
        let colors:[UIColor] = [
            self.yellowColor,
            self.tanColor
        ]
        textBlock.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: textBlock.frame, colors: colors)
    }
    
}
