//
//  RegisterViewController.swift
//  Public Planner
//
//  Created by Clifford Yin on 8/20/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import Firebase
import UIKit
import ChameleonFramework

/* Code that manages the register page of Public Planner */
class RegisterViewController: UIViewController {
    
    var ref = FIRDatabase.database().reference()
    var login = false
    let yellowColor = UIColor.init(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
    let tanColor = UIColor.init(red: 255/255, green: 255/255, blue: 0/255, alpha: 0)
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordConfirmText: UITextField!
    @IBOutlet weak var textBlock: UILabel!
    
    
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
        // Implements Chameleon graphics
        let colors:[UIColor] = [
            self.yellowColor,
            self.tanColor
        ]
        textBlock.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: textBlock.frame, colors: colors)
        
    }
    
   // Processes user's attempt to register a new account
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if (self.passwordText.text == self.passwordConfirmText.text) {
        FIRAuth.auth()?.createUser(withEmail: usernameText.text!, password: passwordText.text!) { (user, error) in
            
            if user?.uid != nil  {
            self.login = true
            self.ref.child("users").child(user!.uid).setValue(["username": self.usernameText.text!])

                } else {
            
                let alertController = UIAlertController(title: "Could not register", message: "Make sure you are registering with your email.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            
            }
        
            if self.login == true {
                LoginManager.sharedInstance.isLoggedIn = true
                
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.present(secondViewController, animated: true)
                    } else {
                        }
                    }
            } else {
                let alertController = UIAlertController(title: "Could not register", message: "Make sure your passwords match.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    
    // Processes user attempt to log in
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(secondViewController, animated: true)
        
    }
    
}
