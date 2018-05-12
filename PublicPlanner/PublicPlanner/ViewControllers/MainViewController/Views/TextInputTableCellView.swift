//
//  TextInputTableCellView.swift
//  Public Planner
//
//  Created by Clifford Yin on 7/23/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//


import UIKit

/* Code that constitutes the main data displayed for an event */
class TextInputTableCellView: UITableViewCell{
    
    @IBOutlet weak var transit: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(_ text: String?, dateText: String) {
        textField.text = text
        textField.accessibilityValue = text
        
        dateLabel.text = dateText
    }
}
