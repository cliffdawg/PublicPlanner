//
//  SavedDetail.swift
//  Public Planner
//
//  Created by Clifford Yin on 7/25/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import UIKit

/* Code that constitutes the description of an event */
class SavedDetail: UIViewController{
    
    var toPass:String!
    @IBOutlet weak var savedNote: UITextView!
    
    // Sets up UI for event description
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        savedNote.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 0, alpha: 1.0).cgColor
        savedNote.layer.borderWidth = 5.0
        savedNote.layer.cornerRadius = 5
        savedNote.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);        // Do view setup here.
        savedNote.autocorrectionType = UITextAutocorrectionType.no;
        savedNote.text = toPass
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    
}
