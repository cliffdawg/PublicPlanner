//
//  AddEventViewController.swift
//  Public Planner
//
//  Created by Clifford Yin on 7/24/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

protocol AddEventViewControllerDelegate {
    func addNew(_ todo: Event)
}

/* Controller to add to a user's own events */
class AddEventViewController: UIViewController, UITextFieldDelegate {

    var ref = FIRDatabase.database().reference()
    var dateData = ""
    var numberDate = ""
    var delegate: AddEventViewControllerDelegate!
    
    //MARK: IBOutlets
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var date: UIDatePicker!
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
            
            self.present(alertController, animated: true, completion: nil)        }
        
        noteText.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 0, alpha: 1.0).cgColor
        noteText.layer.borderWidth = 5.0
        noteText.layer.cornerRadius = 5
        noteText.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);        // Do view setup here.
        noteText.autocorrectionType = UITextAutocorrectionType.no;
        nameText.autocorrectionType = UITextAutocorrectionType.no;          self.automaticallyAdjustsScrollViewInsets = false
        //date
        date.addTarget(self, action: #selector(AddEventViewController.handler(_:)), for: UIControlEvents.valueChanged)
        let colors:[UIColor] = [
            UIColor.yellow,
            UIColor.white
        ]
        textBlock.backgroundColor = GradientColor(gradientStyle: .leftToRight, frame: textBlock.frame, colors: colors)
        nameText.delegate = self as! UITextFieldDelegate
        
        let timeFormatter = DateFormatter()
        let timeFormatter2 = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.short
        timeFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = timeFormatter.string(from: Date())
        
        dateData = strDate
        timeFormatter2.dateFormat = "yy/MM/dd HH:mm"
        
        let numericDate = timeFormatter2.string(from: date.date)
        numberDate = numericDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: IBActions
    
    // Saves the user event in Firebase
    @IBAction func saveEvent(_ sender: UIBarButtonItem) {
        let item = Event(name: nameText.text!, note: noteText.text, dated: dateData, orderDate: numberDate)
        delegate.addNew(item)
        _ = navigationController?.popViewController(animated: true)
        
        //add Data
        let user = FIRAuth.auth()?.currentUser
        self.ref.child("users").child(user!.uid).child("events").child(nameText.text!).setValue(["date": dateData, "detail": noteText.text!, "numericDate": numberDate])
    }
    
    // The title of the event is limited at 27 characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        
        if (range.length + range.location > currentCharacterCount){
            return false
            }
        let newLength = currentCharacterCount + string.characters.count - range.length

        if ((string.contains(".")) || (string.contains("#")) || (string.contains("$")) || (string.contains("[")) || (string.contains("]"))) {
            return false
        }
        
        return newLength <= 27
    }
    
   // Handles the data sent by the datePicker
    @objc 
    func handler(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        let timeFormatter2 = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.short
        timeFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = timeFormatter.string(from: date.date)
        
        dateData = strDate
        timeFormatter2.dateFormat = "yy/MM/dd HH:mm"

        let numericDate = timeFormatter2.string(from: date.date)
        numberDate = numericDate
        // do what you want to do with the string.
        print("\(numericDate)")
    }
    
}
