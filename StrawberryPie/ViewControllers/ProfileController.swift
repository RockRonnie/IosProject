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
  var user: User?
  var url = String()
  var selectedState: String?
  
  
  @IBOutlet weak var segmentButtons: UISegmentedControl!
  @IBOutlet weak var unameLabel: UILabel!
  @IBOutlet weak var joinDateLabel: UILabel!
  @IBOutlet weak var editProfileBtn: UIButton!
  @IBOutlet weak var testImage: UIImageView!
  @IBOutlet weak var xtraInfo: UITextView!
  @IBOutlet weak var userInfoView: UITextView!
  @IBOutlet weak var interestTableView: UITableView!
  @IBOutlet weak var logOutBtn: UIButton!
  @IBOutlet weak var expertLabel: UILabel!
  @IBOutlet weak var realNameLabel: UITextField!
  @IBOutlet weak var topBar: UIView!
  
  
  // Profile pic selection
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
    // SET COLORS and STYLES
    segmentButtons.tintColor = judasBlue()
    self.view.backgroundColor = judasGrey()
    logOutBtn.backgroundColor = judasGrey()
    logOutBtn.setTitleColor(judasBlue(), for: .normal)
    logOutBtn.layer.borderWidth = 2.0
    logOutBtn.layer.borderColor = judasBlue().cgColor
    logOutBtn.layer.cornerRadius = 5
    editProfileBtn.backgroundColor = judasGrey()
    editProfileBtn.setTitleColor(judasBlue(), for: .normal)
    editProfileBtn.layer.borderWidth = 2.0
    editProfileBtn.layer.borderColor = judasBlue().cgColor
    editProfileBtn.layer.cornerRadius = 5
    interestTableView.layer.borderWidth = 2.0
    interestTableView.layer.borderColor = judasBlack().cgColor
    userInfoView.layer.cornerRadius = 0
    userInfoView.layer.borderColor = judasBlack().cgColor
    userInfoView.layer.borderWidth = 2.0
    realNameLabel.layer.cornerRadius = 0
    realNameLabel.layer.borderColor = judasBlack().cgColor
    realNameLabel.layer.borderWidth = 2.0
    xtraInfo.layer.borderWidth = 2.0
    xtraInfo.layer.borderColor = judasBlack().cgColor
    xtraInfo.layer.cornerRadius = 0
    xtraInfo.delegate = self
    xtraInfo.text = ""
    userInfoView.text = ""
    userInfoView.delegate = self
    userInfoView.isEditable = false
    interestTableView.isHidden = true
    expertLabel.textColor = judasRed()
    setupTable()
    realmSetup()
    getState()
    editProfileBtn.isHidden = true
    xtraInfo.isEditable = false
    xtraInfo.isHidden = false
    // Slightly grayish white
    topBar.layer.backgroundColor = UIColor(displayP3Red: 0.9686, green: 0.9686, blue: 0.9686, alpha: 1).cgColor
    topBar.layer.borderWidth = 0.5
    topBar.layer.borderColor = UIColor.gray.cgColor
    segmentButtons.setTitle((NSLocalizedString("About Me", value: "About Me", comment: "Selected segment")), forSegmentAt: 0)
    
    segmentButtons.setTitle((NSLocalizedString("Interests", value: "Interests", comment: "Selected segment")), forSegmentAt: 1)
    
    
    let users = realm.objects(User.self)
    let imagePost = UserImagePost()
    for user in users {
      print(user)
      if user.userID == RealmDB.sharedInstance.user?.identity {
        editProfileBtn.isHidden = false
        editProfileBtn.setTitle(NSLocalizedString("Edit Profile", value: "Edit Profile", comment: "Edit Profile"), for: .normal)
        unameLabel.text = user.userName
        
        // Check if user is an expert
        if user.userExpert {
          expertLabel.text = "Expert"
        } else {
          expertLabel.text = ""
        }
        joinDateLabel.text = user.Account_created.dateToString(dateFormat: "dd-MM-yyyy HH:mm")
        if user.firstName != "" && user.lastName != "" {
          realNameLabel.text = "\(user.firstName)" + " \(user.lastName)"
        } else {
          realNameLabel.text = NSLocalizedString("Name not defined", value: "Name not defined", comment: "fullname")
          realNameLabel.isEnabled = false
        }
        if user.info != "" {
          userInfoView.text = user.info
        } else {
          userInfoView.text = NSLocalizedString("Occupation not defined", value: "Occupation not defined", comment: "occupation")
        }
        if user.extraInfo != "" {
          xtraInfo.text = user.extraInfo
        } else {
          xtraInfo.text = NSLocalizedString("No info given", value: "No info given", comment: "fullname")
        }
        if user.userInterests.count > 0 {
          interestTableView.isHidden = true
        }
        imagePost.getPic(image: user.uImage, onCompletion: {(resultImage) in
          if let result = resultImage {
            self.testImage.image = result
            
          }
        })
      }
    }
    
    testImage.layer.masksToBounds = true
    testImage.layer.cornerRadius = 10
  }
  func setupTable(){
    interestTableView.delegate = self
    interestTableView.dataSource = self
    interestTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    interestTableView.reloadData()
  }
  func realmSetup(){
    realm = RealmDB.sharedInstance.realm
    user = RealmDB.sharedInstance.getUser()
    
  }
  // State for segmentButton
  func setState(state: String){
    selectedState = state
  }
  //Initial state of the segmentButton
  func initialState(){
    setState(state: "About Me")
  }
  // Setup tableview and realm
  
  
  @IBAction func segmentAction(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      print("About Me")
      interestTableView.isHidden = true
      setState(state: "About Me")
      if xtraInfo.text != "" {
      xtraInfo.isHidden = false
      } else {
      xtraInfo.isHidden = true
      }
      case 1:
      print("Interests")
      xtraInfo.isHidden = true
      setState(state: "Interests")
      if interestTableView.visibleCells.isEmpty {
      interestTableView.isHidden = true
      } else {
      interestTableView.isHidden = false
      }
    default:
      print("ERROR: Segment Error")
    }
  }
  func getState(){
    switch selectedState {
    case "About Me":
      if userInfoView.text == ""{
        userInfoView.isHidden = true
      } else {
        userInfoView.isHidden = false
      }
    case "Interests":
      if interestTableView.visibleCells.isEmpty {
        interestTableView.isHidden = true
      } else {
        interestTableView.isHidden = false
      }
    default: print("No page to show")
    }
  }
  
  // Edit Profile and update to realm, switch between Edit and Save
  // Depends on the title "Edit Profile" or "Save", really crude, but works fine
  @IBAction func editProfile(_ sender: UIButton!) {
    if editProfileBtn.titleLabel?.text == NSLocalizedString("Edit Profile", value: "Edit Profile", comment: "Edit Profile") {
      userInfoView.isEditable = true
      xtraInfo.isEditable = true
      realNameLabel.isEnabled = true
      getState()
      editProfileBtn.setTitle(NSLocalizedString("Save", value: "Save", comment: "Save"), for: .normal)
      // Change colors of editable fields
      userInfoView.layer.borderWidth = 3
      userInfoView.layer.borderColor = judasOrange().cgColor
      xtraInfo.layer.borderWidth = 3
      xtraInfo.layer.borderColor = judasOrange().cgColor
      realNameLabel.layer.borderWidth = 3
      realNameLabel.layer.borderColor = judasOrange().cgColor
    }
    if editProfileBtn.titleLabel?.text == NSLocalizedString("Save", value: "Save", comment: "Save") {
      let users = realm.objects(User.self)
      for user in users {
        print(user)
        if user.userID == RealmDB.sharedInstance.user?.identity {
          try! self.realm.write {
            user.info = self.userInfoView.text ?? ""
            user.extraInfo = self.xtraInfo.text ?? ""
            self.realm.add(user, update: Realm.UpdatePolicy.modified)
          }
          userInfoView.isEditable = false
          xtraInfo.isEditable = false
          realNameLabel.isEnabled = false
          // Check if user enters empty fields
          if realNameLabel.text == "" {
            realNameLabel.text = NSLocalizedString("Name not defined", value: "Name not defined", comment: "fullname")
          }
          if userInfoView.text == "" {
            userInfoView.text = NSLocalizedString("Occupation not defined", value: "Occupation not defined", comment: "occupation")
          }
          if xtraInfo.text == "" {
            xtraInfo.text = NSLocalizedString("No info given", value: "No info given", comment: "fullname")
          }
          getState()
          editProfileBtn.setTitle(NSLocalizedString("Edit Profile", value: "Edit Profile", comment: "Edit Profile"), for: .normal)
          // Change borders back to black
          xtraInfo.layer.borderWidth = 2.0
          xtraInfo.layer.borderColor = judasBlack().cgColor
          userInfoView.layer.borderWidth = 2.0
          userInfoView.layer.borderColor = judasBlack().cgColor
          realNameLabel.layer.borderWidth = 2
          realNameLabel.layer.borderColor = judasBlack().cgColor
        }
      }
    }
  }
  // LOG OUT BUTTON
  @IBAction func logOut(_ sender: UIButton!) {
    //Create alert to confirm logout
    let alertController = UIAlertController(title: NSLocalizedString("Log Out", value: "Log Out?", comment: "Log Out"), message: "", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: NSLocalizedString("Yes, Log Out", value: "Yes, Log Out", comment: "Yes, Log Out"), style: .destructive, handler: {
      alert -> Void in
      //SYNCUSER LOGOUT DOES NOT WORK CURRENTLY, NEEDS MORE RESEARCH, NOT A REAL LOGOUT
      let main = UIStoryboard(name: "Main", bundle: nil)
      RealmDB.sharedInstance.user?.logOut()
      print("Logged OUT USER")
      let loggedOut: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedOutTabBar") as? UITabBarController
      self.present(loggedOut!, animated:  true, completion: nil)
    }))
    alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel Log Out", value: "Cancel Log Out", comment: "Cancel log out"), style: .destructive, handler: nil))
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
// TABLEVIEW EXTENSION
extension ProfileController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return user?.userInterests.count ?? 0
  }
  // Populate tableview with CoreData
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = user?.userInterests[indexPath.item] ?? ""
    return cell
  }
  
  // Set height
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 35
  }
  
}









