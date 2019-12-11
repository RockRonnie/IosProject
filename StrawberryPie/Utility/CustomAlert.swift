//
//  CustomAlert.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo on 11/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit

// Custom alert, can be modified later
// Creates Localization base, both title and reason can be localized in a separate localization file ("title" = "LocalizedTitle"; or "reason" = "localizedReason";
// comment is created for the specific alert
struct CustomAlert {
  static func customAlert(title: String, reason: String, comment: String) -> UIAlertController {
    let alert = UIAlertController(title: NSLocalizedString(title, value: title, comment: comment), message: NSLocalizedString(reason, value: reason, comment: comment), preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    return alert
  }
  
}
