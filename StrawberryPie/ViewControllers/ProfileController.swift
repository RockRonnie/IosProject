//
//  ProfileController.swift
//  StrawberryPie
//
//  Created by Joachim Grotenfelt on 20/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation
import UIKit

class ProfileController: UIViewController {
    

    @IBAction func LogOut(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedOutTabBar") as? UITabBarController
        
        self.present(loggedIn!, animated:  true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}
