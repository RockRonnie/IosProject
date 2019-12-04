//
//  ProfileController.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo on 23/11/2019, modified on 27/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift



class ProfileController: UIViewController {
  var realm: Realm!
    var url = String()
    
  @IBOutlet weak var unameLabel: UILabel!
  
  
    @IBOutlet weak var testImage: UIImageView!
    
    @IBAction func selectProfilePic(_ sender: Any) {
        ImagePickerManager().pickImage(self) {image in
            let data = UIImage.pngData(image)
            let imagePost = UserImagePost()
            //calling the post request method and passing he image data and other paramters
            imagePost.requestWith(endUrl: "", imageData: data(), parameters: ["photo" : FILE()], onCompletion: { (response) in
                if let result = response {
                    print("result JSON: \(result)")
                    print("URL: \(result["uri"].stringValue)")
                    //Converting string to URL and turning that into an UIImage
                    let url = URL(string: result["uri"].stringValue)
                    let userObj = RealmDB.sharedInstance.getUser()
                    try! self.realm.write {
                            userObj?.uImage = result["uri"].stringValue
                    }
                    if let data = try? Data(contentsOf: url!){
                        let img: UIImage = UIImage(data: data)!
                        self.testImage.image = img
                    }
                }
            }, onError: { (result) in
                print(result as Any)
            })
        }
    }
    @IBOutlet weak var logOut: UIButton!
   override func viewDidLoad() {
    super.viewDidLoad()
    
    
    realm = RealmDB.sharedInstance.realm
    let users = realm.objects(User.self)
      
    for user in users {
      print(user)
      if user.userID == RealmDB.sharedInstance.user?.identity {
        unameLabel.text = user.userName
      }
    }
  

    
    
    
    
    
    // Do any additional setup after loading the view.
  }
  @IBAction func logOut(_ sender: UIButton!) {
    //Create alert to confirm logout
    let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Yes, Logout", style: .destructive, handler: {
      alert -> Void in
      //SYNCUSER LOGOUT DOES NOT WORK CURRENTLY, NEEDS MORE RESEARCH, NOT A REAL LOGOUT
      let main = UIStoryboard(name: "Main", bundle: nil)
      RealmDB.sharedInstance.user?.logOut()
      print("Logged OUT USER")
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


