//
//  ViewController.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo on 19/11/2019, modified on 27/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class LoginRegisterController: UIViewController, UITextFieldDelegate {
  
  var signUpFormEnabled = Bool()
  let messageLabel = UILabel()
  let changeFormButton = UIButton(type: .roundedRect)
  let loginButton = UIButton(type: .roundedRect)
  let signUpButton = UIButton(type: .roundedRect)
  let cancelButton = UIButton(type: .roundedRect)
  let infoAddedButton = UIButton(type: .roundedRect)
  let errorLabel = UILabel()
  let userEmailField = UITextField()
  let usernameField = UITextField()
  let firstnameField = UITextField()
  let lastnameField = UITextField()
  let userinfoField = UITextField()
  let userXtraInfoField = UITextField()
  let userpasswordField = UITextField()
  let userpwagainField = UITextField()
  
  var realm: Realm!
  var user: SyncUser?
  let main = UIStoryboard(name: "Main", bundle: nil)
  let thisUser = User()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    usernameField.delegate = self
    userpasswordField.delegate = self
    userinfoField.delegate = self
    userpwagainField.delegate = self
    firstnameField.delegate = self
    lastnameField.delegate = self
    
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
    cancelButton.isHidden = true
    changeFormButton.isHidden = false
    infoAddedButton.isHidden = true
    
    // Initial swap of forms to get Loginform to show
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
    userpasswordField.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit; max-consecutive: 2; minlenght: 8;")
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
    
    // Buttons
    // LOGIN BUTTON
    loginButton.setTitle("Login", for: .normal)
    loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    // SIGNUP BUTTON
    signUpButton.setTitle("Sign up", for: .normal)
    signUpButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
    // DONE BUTTON TO CONTINUE FOR SIGNUP PT. 2
    infoAddedButton.setTitle("Done", for: .normal)
    infoAddedButton.addTarget(self, action: #selector(advancedSignup), for: .touchUpInside)
    changeFormButton.addTarget(self, action: #selector(switchForm),
                               for: .touchUpInside)
    // IF YOU DONT WANT TO SET USER CUSTOMIZATION NOW
    cancelButton.setTitle("Cancel, you can modify later", for: .normal)
    cancelButton.addTarget(self, action: #selector(cancelRegister), for: .touchUpInside)
    
    // Add buttons, cancelButton for cancelling extra signup details
    container.addArrangedSubview(loginButton)
    container.addArrangedSubview(signUpButton)
    container.addArrangedSubview(changeFormButton)
    container.addArrangedSubview(cancelButton)
    container.addArrangedSubview(infoAddedButton)
    
    // Container's location on the screen
    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      container.centerXAnchor.constraint(equalTo: guide.centerXAnchor, constant: 0),
      container.centerYAnchor.constraint(equalTo: guide.centerYAnchor, constant: -100),
      
      ])
    
    
    
  }
  // NOT IN USE, might be used later
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
  }
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
  
  // To reduce clutter calling alert
  func customAlert(title: String, reason: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: reason, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    return alert
    
  }
  
  
  func loginRealm(_ username: String,_ password: String,_ register: Bool){
    // Yritä kirjautua sisään --> Vaihda kovakoodatut tunnarit pois
    let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
    SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: Constants.AUTH_URL) { user, error in
      if let user = user {
        RealmDB.sharedInstance.user?.logOut()
        // Onnistunut kirjautuminen
        // Lähetetään permission realmille -> read/write oikeudet käytössä olevalle palvelimelle. realmURL: Constants.REALM_URL --> Katso Constants.swift
        let permission = SyncPermission(realmPath: Constants.REALM_URL.absoluteString, username: "\(username)", accessLevel: .write)
        user.apply(permission, callback: { (error) in
          if error != nil {
            print(error?.localizedDescription ?? "No error")
          } else {
            print("success")
          }
        })
        self.user = user
        let admin = user.isAdmin
        print(admin)
        RealmDB.sharedInstance.user = self.user
        // Leivotaan realmia varten asetukset. realmURL: Constants.REALM_URL --> Katso Constants.swift
        let config = user.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config)
        RealmDB.sharedInstance.realm = self.realm
        print("Realm connection has been setup")
        print("Changing navigators")
        self.present(loggedIn!, animated:true, completion: nil)
      } else if let error = error {
        print("Login error: \(error)")
        self.present(self.customAlert(title: "Login", reason: "Wrong login"), animated: true, completion: nil)
      }
    }
    
  }
  
  
  // SIGNUP FUNCTION EARLY VERSION, SUBJECT TO CHANGE
  func signUp(_ username: String, _ password: String, _ register: Bool) {
    let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
    if usernameField.text == "" {
      self.present(customAlert(title: "uname", reason: "Missing username"), animated: true, completion: nil)
    } else if userpasswordField.text == "" {
      self.present(customAlert(title: "upw", reason: "Missing password"),
                   animated: true, completion: nil)
    } else if userpasswordField.text != "" && userpwagainField.text == "" {
      self.present(customAlert(title: "upw", reason: "Please confirm password"),
                   animated: true, completion: nil)
    } else if usernameField.text != "" && userpasswordField.text != "" && userpwagainField.text != "" {
      
      
      SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: true), server: Constants.AUTH_URL) { user, error in
        if let user = user {
          
          RealmDB.sharedInstance.user?.logOut()
          // Onnistunut kirjautuminen
          // Lähetetään permission realmille -> read/write oikeudet käytössä olevalle palvelimelle. realmURL: Constants.REALM_URL --> Katso Constants.swift
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
          alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in self.advancedSignup(user: self.thisUser) }))
          alert.addAction(UIAlertAction(title: "Do it later", style: .cancel, handler: nil))
          self.present(alert, animated: true)
          print("Realm connection has been setup")
          print("Changing navigators")
          self.present(loggedIn!, animated:true, completion: nil)
        } else if let error = error {
          print("Signup error!: \(error)")
          self.present(self.customAlert(title: "Signup", reason: "User exists"), animated: true, completion: nil)
        }
        
        
        
        
      }
     
      
     
    }
  }
  
  func signIn() {
    logIn(username ?? "", password ?? "", false)
  }
  func createUser() {
    
    signUp(username ?? "", password ?? "", true)
  }
  func cancelRegister() {
    let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
    self.present(loggedIn!, animated: true, completion: nil)
  }
  func advancedSignup(user: User) {
    RealmDB.sharedInstance.user = self.user
    // Leivotaan realmia varten asetukset. realmURL: Constants.REALM_URL --> Katso Constants.swift
    let config = self.user?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
    if let cfg = config {
      self.realm = try! Realm(configuration: cfg)
    } else {
      print("Error")
      return
    }
    self.changeFormButton.isHidden = true
    self.signUpButton.isHidden = true
    self.cancelButton.isHidden = false
    self.userXtraInfoField.isHidden = false
    self.userinfoField.isHidden = false
    signUpFormEnabled = true
    realm = RealmDB.sharedInstance.realm
    let users = realm.objects(User.self)
    
    for user in users {
      print(user)
      let thisUserUpdated = User()
      if user.userID == RealmDB.sharedInstance.user?.identity {
        thisUserUpdated.firstName = firstnameField.text ?? ""
        thisUserUpdated.lastName = lastnameField.text ?? ""
        thisUserUpdated.info = userinfoField.text ?? ""
        // EXPERT STATUS TO BE IMPLEMENTED LATER
        thisUserUpdated.userExpert = false
        thisUserUpdated.userEmail = userEmailField.text ?? ""
        thisUserUpdated.info = userinfoField.text ?? ""
        thisUserUpdated.extraInfo = userXtraInfoField.text ?? ""
        }
      try! self.realm.write {
        self.realm.add(thisUserUpdated, update: Realm.UpdatePolicy.modified)
    }
    
    }
  }
  // Change between login / register
  func switchForm() {
    self.changeFormButton.isHidden = false
    if signUpFormEnabled {
      // LOGIN Form chosen -> Show login fields
      signUpFormEnabled = false
      self.messageLabel.text = "Please enter your login information"
      self.firstnameField.isHidden = true
      self.lastnameField.isHidden = true
      self.userpwagainField.isHidden = true
      self.userinfoField.isHidden = true
      self.userXtraInfoField.isHidden = true
      self.userEmailField.isHidden = true
      self.loginButton.isHidden = false
      self.signUpButton.isHidden = true
      changeFormButton.setTitle("Sign up instead", for: .normal)
    } else if
      !signUpFormEnabled {
      signUpFormEnabled = true
      self.messageLabel.text = "Please fill out the registration form"
      // SIGNUP Form chosen -> Show signup fields

      self.userpwagainField.isHidden = false
      self.firstnameField.isHidden = false
      self.lastnameField.isHidden = false
      self.userXtraInfoField.isHidden = true
      self.userEmailField.isHidden = false
      self.userinfoField.isHidden = true
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
  public var currentUser: User {
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
  // NOT USED but might be useful, can set and get bool
  var userDef: Bool {
    get {
      return UserDefaults.standard.bool(forKey: "userExists")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "userExists")
    }
  }
}


