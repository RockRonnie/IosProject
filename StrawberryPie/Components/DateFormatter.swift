//
//  DateFormatter.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo on 09/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit

class Formatters {
  
  func DateFormatter(format : String) -> String {
    let formatter = DateFormatter(format: Date)
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    let dateString = formatter.string(from: Date())
    if let myDate = formatter.date(from: dateString) {
      let dateToString = formatter.string(from: myDate)
    
    }
  formatter.dateFormat = "dd-MMM-yyyy"
  }
}
