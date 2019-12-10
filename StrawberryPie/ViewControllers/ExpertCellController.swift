//
//  ExpertCellController.swift
//  StrawberryPie
//
//  Created by iosdev on 01/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ExpertCellController: UITableViewCell{
    @IBOutlet weak var expertImage: UIImageView!
    @IBOutlet weak var expertTitle: UILabel!
    @IBOutlet weak var expertName: UILabel!
    @IBOutlet weak var expertDesc: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 0, left:0, bottom: 10, right: 0)
        bounds = bounds.inset(by: margins)
        
    }
}
