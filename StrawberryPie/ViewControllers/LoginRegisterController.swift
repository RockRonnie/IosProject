//
//  LoginRegisterController.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo on 19/11/2019, modified on 27/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class LoginRegisterController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
  
  var category = Category()
  var realm: Realm!
  var user: SyncUser?
  let main = UIStoryboard(name: "Main", bundle: nil)
  let thisUser = User()
  
  // Interestlist outlets
  @IBOutlet weak var categoryTable: UITableView!
  @IBOutlet weak var interestOne: UILabel!
  @IBOutlet weak var interestTwo: UILabel!
  @IBOutlet weak var interestThree: UILabel!
  @IBOutlet weak var interestError: UILabel!
  @IBOutlet weak var chooseLabel: UILabel!
  @IBOutlet weak var removeInterestOne: UIButton!
  @IBOutlet weak var removeInterestTwo: UIButton!
  @IBOutlet weak var removeInterestThree: UIButton!
  @IBOutlet weak var cancelBtn: UIButton!
  @IBOutlet weak var doneBtn: UIButton!
  
  // Create page content
  var signUpFormEnabled = Bool()
  let messageLabel = UILabel()
  let changeFormButton = UIButton(type: .roundedRect)
  let loginButton = UIButton(type: .roundedRect)
  let signUpButton = UIButton(type: .roundedRect)
  let infoAddedButton = UIButton(type: .roundedRect)
  let userEmailField = UITextField()
  let usernameField = UITextField()
  let firstnameField = UITextField()
  let lastnameField = UITextField()
  let userinfoField = UITextField()
  let userXtraInfoField = UITextField()
  let userpasswordField = UITextField()
  let userpwagainField = UITextField()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.categoryTable.delegate = self
    self.categoryTable.dataSource = self
    self.categoryTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    // Show only login fields
    usernameField.isHidden = false
    userpasswordField.isHidden = false
    userinfoField.isHidden = true
    userpwagainField.isHidden = true
    userEmailField.isHidden = true
    userXtraInfoField.isHidden = true
    firstnameField.isHidden = true
    lastnameField.isHidden = true
    loginButton.isHidden = true
    signUpButton.isHidden = true
    changeFormButton.isHidden = false
    infoAddedButton.isHidden = true
    cancelBtn.isHidden = true
    doneBtn.isHidden = true
    // Enabling signup and switching it back again to set initial values to match login form
    self.signUpFormEnabled = true
    self.switchForm()
    
    // Container, can be used for additional information on the screen, is built programmatically
    let container = UIStackView()
    messageLabel.numberOfLines = 0
    messageLabel.text = "Please enter your login information"
    container.addArrangedSubview(messageLabel)
    container.translatesAutoresizingMaskIntoConstraints = false
    container.axis = .vertical
    container.alignment = .fill
    container.spacing = 16.0
    view.addSubview(container)
    
    // Create Register / Login Form
    // Styling etc. could be moved to another separate styling file
    // --------------------------------------
    userpwagainField.isSecureTextEntry = true
    userpasswordField.isSecureTextEntry = true
    userinfoField.frame.size.height = 100
    usernameField.placeholder = "Username"
    usernameField.borderStyle = .roundedRect
    usernameField.autocapitalizationType = .none
    firstnameField.placeholder = "First name"
    firstnameField.borderStyle = .roundedRect
    lastnameField.placeholder = "Last name"
    lastnameField.borderStyle = .roundedRect
    userEmailField.placeholder = "Email"
    userEmailField.borderStyle = .roundedRect
    userinfoField.placeholder = "Info"
    userinfoField.borderStyle = .roundedRect
    userXtraInfoField.placeholder = "More Info"
    userXtraInfoField.borderStyle = .roundedRect
    userpasswordField.placeholder = "Password"
    userpasswordField.borderStyle = .roundedRect
    userpasswordField.autocapitalizationType = .none
    userpwagainField.placeholder = "Password again"
    userpwagainField.borderStyle = .roundedRect
    userpwagainField.autocapitalizationType = .none
    // Add every text field to container
    container.addArrangedSubview(usernameField)
    container.addArrangedSubview(firstnameField)
    container.addArrangedSubview(lastnameField)
    container.addArrangedSubview(userEmailField)
    container.addArrangedSubview(userpasswordField)
    container.addArrangedSubview(userpwagainField)
    container.addArrangedSubview(userinfoField)
    container.addArrangedSubview(userXtraInfoField)
    
    // Hide interest table initially
    categoryTable.isHidden = true
    interestOne.isHidden = true
    interestTwo.isHidden = true
    interestThree.isHidden = true
    removeInterestOne.isHidden = true
    removeInterestTwo.isHidden = true
    removeInterestThree.isHidden = true
    chooseLabel.isHidden = true
    interestOne.text = ""
    interestTwo.text = ""
    interestThree.text = ""
    interestError.text = ""
    
    // LOGIN BUTTON
    loginButton.setTitle("Login", for: .normal)
    loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    // SIGNUP BUTTON
    signUpButton.setTitle("Sign up", for: .normal)
    signUpButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
    // SWAP FORMS BUTTON
    changeFormButton.setTitle("No account? Register", for: .normal)
    changeFormButton.addTarget(self, action: #selector(switchForm), for: .touchUpInside)
    
    // Add buttons, cancelButton for cancelling extra signup details
    container.addArrangedSubview(loginButton)
    container.addArrangedSubview(signUpButton)
    container.addArrangedSubview(infoAddedButton)
    container.addArrangedSubview(changeFormButton)
    
    // Container's location on the screen
    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      container.centerXAnchor.constraint(equalTo: guide.centerXAnchor, constant: 0),
      container.centerYAnchor.constraint(equalTo: guide.centerYAnchor, constant: -180),
      
      ])
  }
  // NOT IN USE, might be used later
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  }
  // Buttons for finishing register or cancelling it
  @IBAction func cancelRegister(_ sender: Any) {
    cancelRegister()
  }
  @IBAction func registerDone(_ sender: Any) {
    advancedSignup()
  }
  // Removebutton for first item in the list
  @IBAction func removeFirst(_ sender: Any) {
    let userUpdatedObj = RealmDB.sharedInstance.getUser()
    realm = RealmDB.sharedInstance.realm
    try! self.realm.write {
      switch self.thisUser.userInterests.count {
      case 0: break
      case 1: // If one item, remove the first
        self.interestOne.text = ""
        self.thisUser.userInterests.remove(at: 0)
        self.removeInterestOne.isHidden = true
      case 2: // If two items, move second to first
        self.thisUser.userInterests.remove(at: 0)
        self.interestOne.text = self.interestTwo.text
        self.interestTwo.text = ""
        self.removeInterestOne.isHidden = false
        self.removeInterestTwo.isHidden = true
        self.removeInterestThree.isHidden = true
      default: // If three items, remove first and move 3 -> 2 2 -> 1
        self.thisUser.userInterests.remove(at: 0)
        self.interestOne.text = self.interestTwo.text
        self.interestTwo.text = self.interestThree.text
        self.interestThree.text = ""
        self.removeInterestOne.isHidden = false
        self.removeInterestTwo.isHidden = false
        self.removeInterestThree.isHidden = true
      }
      userUpdatedObj?.userInterests = self.thisUser.userInterests
      // Update realm, userUpdate is the User object referring to the realm user object, might not be optimal, but works.
      if let userUpdate = userUpdatedObj {
        self.realm.add(userUpdate, update: Realm.UpdatePolicy.modified)
      } else {
        print("No changes")
      }
    }
  }
  // Remove button for second item in the list
  @IBAction func removeSecond(_ sender: Any) {
    let userUpdatedObj = RealmDB.sharedInstance.getUser()
    realm = RealmDB.sharedInstance.realm
    try! self.realm.write {
      switch self.thisUser.userInterests.count {
      case 0: break
      case 1: break
      case 2: // If 2 items in the list, only remove second item and hide remove button
        self.thisUser.userInterests.remove(at: 1)
        self.interestTwo.text = ""
        self.interestThree.text = ""
        self.removeInterestTwo.isHidden = true
        self.removeInterestThree.isHidden = true
      default: // If 3 items in the list, move third item in place of second
        self.thisUser.userInterests.remove(at: 1)
        self.interestTwo.text = self.interestThree.text
        self.interestThree.text = ""
        self.removeInterestTwo.isHidden = false
        self.removeInterestThree.isHidden = true
      }
      userUpdatedObj?.userInterests = self.thisUser.userInterests
      // Update realm, userUpdate is the User object referring to the realm user object
      if let userUpdate = userUpdatedObj {
        self.realm.add(userUpdate, update: Realm.UpdatePolicy.modified)
      } else {
        print("No changes")
      }
    }
  }
  // Remove button for third item in the list
  @IBAction func removeThird(_ sender: Any) {
    let userUpdatedObj = RealmDB.sharedInstance.getUser()
    realm = RealmDB.sharedInstance.realm
    try! self.realm.write {
      switch self.thisUser.userInterests.count {
      case 0: break // 0 items
      case 1: break // 1 item in the list (cant be third item present)
      case 2: break // 2 items in the list (cant be third item present)
      default: // remove third item
        self.thisUser.userInterests.remove(at: 2)
        self.interestThree.text = ""
        self.removeInterestThree.isHidden = true
        
      }
      userUpdatedObj?.userInterests = self.thisUser.userInterests
      // Update realm, userUpdate is the User object referring to the realm user object
      if let userUpdate = userUpdatedObj {
        self.realm.add(userUpdate, update: Realm.UpdatePolicy.modified)
      } else {
        print("No changes")
      }
    }
  }
  // Tableview rowcount to match CoreData
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let rowCount = category.getNames().count
    return rowCount
  }
  // Populate tableview with CoreData
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let interestCategories = category.getNames()
    cell.textLabel?.text = interestCategories[indexPath.item]
    return cell
  }
  // Set height
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 35
  }
  // Category picked already or not
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    let interestCategories = category.getNames()
    self.interestError.text = ""
    let selectedCategory = interestCategories[indexPath.item]
    // If userinterest list contains the picked tableview category
    if self.thisUser.userInterests.contains(selectedCategory) {
      self.interestError.text = "Category already picked"
    } else {
      // If it does not, add to userinterests
      let userUpdatedObj = RealmDB.sharedInstance.getUser()
      realm = RealmDB.sharedInstance.realm
      // Check that user does not empty password field
      try! self.realm.write {
        self.thisUser.userInterests.append(selectedCategory)
        userUpdatedObj?.userInterests = self.thisUser.userInterests
        // Update realm, userUpdate is the User object referring to the realm user object, might not be optimal, but works.
        if let userUpdate = userUpdatedObj {
          self.realm.add(userUpdate, update: Realm.UpdatePolicy.modified)
        } else {
          print("No changes")
        }
      }
      
      
      // Switch case for showing interests on the screen
      
      switch self.thisUser.userInterests.count {
      case 1:
        self.interestOne.text = selectedCategory
        removeInterestOne.isHidden = false
      case 2:
        self.interestTwo.text = selectedCategory
        removeInterestTwo.isHidden = false
      case 3:
        self.interestThree.text = selectedCategory
        removeInterestThree.isHidden = false
      case 4:
        self.interestError.text = "All 3 categories picked"
      default:
        removeInterestOne.isHidden = true
        removeInterestTwo.isHidden = true
        removeInterestThree.isHidden = true
        self.interestOne.text = ""
        self.interestTwo.text = ""
        self.interestThree.text = ""
      }
    }
  }
  
  
  
  
  
  
  // deletion func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  //  if editingStyle == .delete {
  //    self.thisUser.userInterests.remove(at: indexPath.row)
  //    tableView.deleteRows(at: [indexPath], with: .fade)
  //  }
  
  // }
  // Login function, check for username and password
  func logIn(_ username: String,_ password: String,_ register: Bool) {
    if usernameField.text == "" {
      self.present(customAlert(title: "uname", reason: "Missing username"), animated: true, completion: nil)
    } else if userpasswordField.text == "" {
      self.present(customAlert(title: "upw", reason: "Missing password"),
                   animated: true, completion: nil)
    } else {
      // ALL IS GOOD => LOGIN
      loginRealm(username, password, register)
    }
    
  }
  
  // Custom alert, can be modified later
  func customAlert(title: String, reason: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: reason, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    return alert
    
  }
  // Login function with username and password
  func loginRealm(_ username: String,_ password: String,_ register: Bool){
    let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
    // Try Logging in
    SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: Constants.AUTH_URL) { user, error in
      // If user is found -> login
      if let user = user {
        RealmDB.sharedInstance.user?.logOut()
        // Login successful
        // Create read/write permissions for the realm, username is the logged user
        let permission = SyncPermission(realmPath: Constants.REALM_URL.absoluteString, username: "\(username)", accessLevel: .write)
        user.apply(permission, callback: { (error) in
          if error != nil {
            print(error?.localizedDescription ?? "No error")
          } else {
            print("success")
          }
        })
        // Check if user admin
        self.user = user
        let admin = user.isAdmin
        print(admin)
        // Realm user is this user
        RealmDB.sharedInstance.user = self.user
        // Create config for realm (Constants.swift)
        let config = user.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config)
        RealmDB.sharedInstance.realm = self.realm
        print("Realm connection has been setup")
        print("Changing navigators")
        // Change tabbar to loggedIn
        self.present(loggedIn!, animated:true, completion: nil)
      } else if let error = error {
        // Error login
        print("Login error: \(error)")
        self.present(self.customAlert(title: "Login", reason: "Wrong login"), animated: true, completion: nil)
      }
    }
    
  }
  
  
  // Signup function
  func signUp(_ username: String, _ password: String, _ register: Bool) {
    // Empty textfield = not valid
    if usernameField.text == "" {
      self.present(customAlert(title: "uname", reason: "Missing username"), animated: true, completion: nil)
    } else if userpasswordField.text == "" {
      self.present(customAlert(title: "upw", reason: "Missing password"),
                   animated: true, completion: nil)
    } else if userpasswordField.text != "" && userpwagainField.text == "" || userpasswordField.text != userpwagainField.text {
      self.present(customAlert(title: "upw", reason: "Please confirm password"),
                   animated: true, completion: nil)
    } else if RegisterValidation.validatePassword(passwordID: userpasswordField.text ?? "") != true {
      self.present(customAlert(title: "password", reason: "Invalid password"),
                   animated: true, completion: nil)
    } else {
      
      // Textfields are not empty and valid => Login
      
      SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: true), server: Constants.AUTH_URL) { user, error in
        if let user = user {
          // logout user in realm instance if exists
          RealmDB.sharedInstance.user?.logOut()
          // Login successful
          // Create read/write permissions for the realm, username is the logged user
          let permission = SyncPermission(realmPath: Constants.REALM_URL.absoluteString, username: "\(username)", accessLevel: .write)
          user.apply(permission, callback: { (error) in
            if error != nil {
              print("Something went wrong: \(String(describing: error?.localizedDescription))")
            } else {
              print("success")
            }
          })
          self.user = user
          RealmDB.sharedInstance.user = self.user
          // Leivotaan realmia varten asetukset. realmURL: Constants.REALM_URL --> Katso Constants.swift
          let config = user.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
          self.realm = try! Realm(configuration: config)
          RealmDB.sharedInstance.realm = self.realm
          guard let userIdentity = self.user?.identity else {
            self.present(self.customAlert(title: "Register Error!", reason: "userIdentity not found"), animated: true, completion: nil)
            return }
          self.thisUser.userID = userIdentity
          self.thisUser.userName = username
          try! self.realm.write {
            self.realm.add(self.thisUser)
          }
          let alert = UIAlertController(title: "Customize?", message: "Do you want to customize your profile now?", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in self.createUserMoreInfo() }))
          alert.addAction(UIAlertAction(title: "Do it later", style: .cancel, handler: { (action: UIAlertAction!) in self.cancelRegister() }))
          self.present(alert, animated: true)
          print("Realm connection has been setup")
          print("Changing navigators")
        } else if let error = error {
          print("Signup error!: \(error)")
          self.present(self.customAlert(title: "Signup", reason: "User exists"), animated: true, completion: nil)
        }
      }
    }
  }
  
  // Functions connecting to Buttons
  func signIn() {
    logIn(username ?? "", password ?? "", false)
  }
  func createUser() {
    
    signUp(username ?? "", password ?? "", true)
  }
  // Enable user fields for registration phase 2
  func createUserMoreInfo() {
    // SHOW RELEVANT FIELDS
    
    self.doneBtn.isHidden = false
    self.cancelBtn.isHidden = false
    self.usernameField.isHidden = true
    self.userpasswordField.isHidden = true
    self.userpwagainField.isHidden = true
    self.firstnameField.isHidden = false
    self.lastnameField.isHidden = false
    self.changeFormButton.isHidden = true
    self.signUpButton.isHidden = true
    self.chooseLabel.isHidden = false
    self.userEmailField.isHidden = false
    self.userXtraInfoField.isHidden = false
    self.userinfoField.isHidden = false
    self.infoAddedButton.isHidden = false
    self.categoryTable.isHidden = false
    self.interestOne.isHidden = false
    self.interestTwo.isHidden = false
    self.interestThree.isHidden = false
  }
  // Go out of register and present logged in tab bar, should only be used for user that has logged in already
  func cancelRegister() {
    let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
    self.present(loggedIn!, animated: true, completion: nil)
  }
  // Registration phase 2 function
  func advancedSignup() {
    // Settings for realm
    let isValidateEmail = RegisterValidation.validateEmail(emailID: self.userEmailField.text ?? "")
    if (isValidateEmail == false){
      self.interestError.text = "Invalid email"
      return
    }
    let config = self.user?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
    if let cfg = config {
      self.realm = try! Realm(configuration: cfg)
    } else {
      self.present(self.customAlert(title: "Signup Error", reason: "Signup Error"), animated: true, completion: nil)
    }
    // Create temporary user object from Realm (check getUser() function in RealmDB.swift for more information)
    let userUpdatedObj = RealmDB.sharedInstance.getUser()
    realm = RealmDB.sharedInstance.realm
    // Check that user does not empty password field
    try! self.realm.write {
      userUpdatedObj?.firstName = self.firstnameField.text ?? ""
      userUpdatedObj?.lastName = self.lastnameField.text ?? ""
      userUpdatedObj?.info = self.userinfoField.text ?? ""
      // EXPERT STATUS TO BE IMPLEMENTED LATER
      userUpdatedObj?.userExpert = false
      userUpdatedObj?.userEmail = self.userEmailField.text ?? ""
      userUpdatedObj?.info = self.userinfoField.text ?? ""
      userUpdatedObj?.extraInfo = self.userXtraInfoField.text ?? ""
      userUpdatedObj?.userInterests = self.thisUser.userInterests
      
      // Update realm, userUpdate is the User object referring to the realm user object, might not be optimal, but works.
      if let userUpdate = userUpdatedObj {
        self.realm.add(userUpdate, update: Realm.UpdatePolicy.modified)
      } else {
        print("No changes")
      }
    }
    // Succesful registration, login ensues
    let alert = UIAlertController(title: "Success!", message: "Registration successful!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in self.cancelRegister() }))
    self.present(alert, animated: true)
    
  }
  
  
  // Change between login / register forms
  func switchForm() {
    self.changeFormButton.isHidden = false
    if signUpFormEnabled {
      // LOGIN Form chosen -> Show login fields
      signUpFormEnabled = false
      self.messageLabel.text = "Please enter your login information"
      self.userpwagainField.isHidden = true
      self.loginButton.isHidden = false
      
      self.signUpButton.isHidden = true
      changeFormButton.setTitle("Sign up instead", for: .normal)
    } else if
      !signUpFormEnabled {
      signUpFormEnabled = true
      self.messageLabel.text = "Please fill out the registration form"
      // SIGNUP Form chosen -> Show signup fields
      self.cancelBtn.isHidden = true
      self.doneBtn.isHidden = true
      self.userpwagainField.isHidden = false
      self.loginButton.isHidden = true
      self.signUpButton.isHidden = false
      changeFormButton.setTitle("Already have an account? Login instead", for: .normal)
    }
    
    
    // Getters
  }
  var firstname: String? {
    get {
      return firstnameField.text
    }
  }
  var lastname: String? {
    get {
      return lastnameField.text
    }
  }
  var info: String? {
    get {
      return userinfoField.text
    }
  }
  var moreInfo: String? {
    get {
      return userXtraInfoField.text
    }
  }
  var currentUser: User {
    get {
      return thisUser
    }
  }
  var username: String? {
    get {
      return usernameField.text
    }
  }
  var password: String? {
    get {
      return userpasswordField.text
    }
  }
}

