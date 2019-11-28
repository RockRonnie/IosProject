//
//  CategoryContentController.swift
//  StrawberryPie
//
//  Created by iosdev on 27/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit

class CategoryContentController: UIViewController {

    
    var topText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = topText
        print(topText)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
