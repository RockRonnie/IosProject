//
//  ProfileController.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo on 23/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift

var realm: Realm!

class ProfileController: UIViewController {

  @IBOutlet weak var logOut: UIButton!
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  @IBAction func logOut(_ sender: UIButton!) {
    let main = UIStoryboard(name: "Main", bundle: nil)
    let loggedOut: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedOutTabBar") as? UITabBarController
    self.present(loggedOut!, animated:  true, completion: nil)
    SyncUser.current?.logOut()
    
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
