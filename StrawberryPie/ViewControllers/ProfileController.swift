//
//  ProfileController.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo / Joachim Grotenfelt on 23/11/2019, modified on 27/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift



class ProfileController: UIViewController, UITextViewDelegate {
  var realm: Realm!
    var url = String()
    
  @IBOutlet weak var unameLabel: UILabel!
  @IBOutlet weak var joinDateLabel: UILabel!
  @IBOutlet weak var companyInfo: UILabel!
  @IBOutlet weak var editProfileBtn: UIButton!
  @IBOutlet weak var testImage: UIImageView!
  @IBOutlet weak var xtraInfo: UITextView!
  @IBOutlet weak var userInfoView: UITextView!
  
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
    
    xtraInfo.delegate = self
    userInfoView.delegate = self
    
    realm = RealmDB.sharedInstance.realm
    let users = realm.objects(User.self)
    let imagePost = UserImagePost()
    editProfileBtn.isHidden = true
    userInfoView.isEditable = false
    xtraInfo.isEditable = false
    userInfoView.layer.borderWidth = 0.5
    userInfoView.layer.borderColor = UIColor.black.cgColor
    xtraInfo.layer.borderWidth = 0.5
    xtraInfo.layer.borderColor = UIColor.black.cgColor
    
    for user in users {
      print(user)
      if user.userID == RealmDB.sharedInstance.user?.identity {
        editProfileBtn.isHidden = false
        unameLabel.text = user.userName
        xtraInfo.text = user.extraInfo
        joinDateLabel.text = user.Account_created.dateToString(dateFormat: "dd-MM-yyyy HH:mm")
        userInfoView.text = user.info
        companyInfo.text = "About me"
        imagePost.getPic(image: user.uImage, onCompletion: {(resultImage) in
            if let result = resultImage {
                self.testImage.image = result
            }
        })
      }
    }
    // Do any additional setup after loading the view.
  }
  // Edit Profile and update to realm, switch between Edit and Save
  @IBAction func editProfile(_ sender: UIButton!) {
    if editProfileBtn.titleLabel?.text == "Edit Profile" {
      userInfoView.isEditable = true
      xtraInfo.isEditable = true
    }
    if editProfileBtn.titleLabel?.text == "Save" {
      let users = realm.objects(User.self)
      for user in users {
        print(user)
        if user.userID == RealmDB.sharedInstance.user?.identity {
          try! self.realm.write {
            user.info = self.userInfoView.text ?? ""
            user.extraInfo = self.xtraInfo.text ?? ""
            self.realm.add(user, update: Realm.UpdatePolicy.modified)
          }
        }
      }
    }
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

// Date formatting
extension Date
{
  func dateToString (dateFormat format: String) -> String
  {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: self)
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


