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
    //Create alert to confirm logout
    let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Yes, Logout", style: .destructive, handler: {
      alert -> Void in
      //SYNCUSER LOGOUT DOES NOT WORK CURRENTLY, NEEDS MORE RESEARCH, NOT A REAL LOGOUT
      //SyncUser.current?.logOut()
      let main = UIStoryboard(name: "Main", bundle: nil)
      let loggedOut: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedOutTabBar") as? UITabBarController
      self.present(loggedOut!, animated:  true, completion: nil)
    }))
    alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
  
  
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


