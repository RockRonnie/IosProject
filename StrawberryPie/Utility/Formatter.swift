//
//  dateFormatter.swift
//  StrawberryPie
//
//  Created by iosdev on 09/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// For formatting timestamps to a more pleasing form. Used in most chat functions.

import Foundation
class Formatter {
    func dateformat(_ timestamp: Date) -> String {
        print(timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let thisTimestamp = formatter.string(from: timestamp)
        //let thisTimestamp = formatter.date(from: timestamp)
        print(thisTimestamp)
        return thisTimestamp
    }    
}
