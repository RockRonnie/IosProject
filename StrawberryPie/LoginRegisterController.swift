//
//  ViewController.swift
//  StrawberryPie
//
//  Created by iosdev on 19/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit

class LoginRegisterController: UIViewController {

    @IBAction func LoginButton(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
        
        self.present(loggedIn!, animated:  true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

