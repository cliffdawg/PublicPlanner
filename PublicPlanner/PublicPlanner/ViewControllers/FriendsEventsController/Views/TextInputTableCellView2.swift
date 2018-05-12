//
//  TextInputTableCellView2.swift
//  Public Planner
//
//  Created by Clifford Yin on 1/2/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit

/* Code that constitutes a friend's event */
class TextInputTableCellView2: UITableViewCell{
    
    // MARK: IBOutlets
    
    @IBOutlet weak var transit: UIButton!
    @IBOutlet weak var dateLabel2: UILabel!
    @IBOutlet weak var textField2: UITextField!
    
    func configurate(_ text: String?, dateText: String) {
        textField2.text = text
        textField2.accessibilityValue = text
        dateLabel2.text = dateText
    }

}
