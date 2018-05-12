//
//  Event.swift
//  Public Planner
//
//  Created by Clifford Yin on 7/24/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import Foundation

/* Code that constitutes an event, with name, detail, date, and order digit */
class Event {
    var name = ""
    var note = ""
    var dated = ""
    var orderDate = ""
    
    init(name: String, note: String, dated: String, orderDate: String) {
        self.name = name
        self.note = note
        self.dated = dated
        self.orderDate = orderDate
    
    }
}
