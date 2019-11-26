//
//  ViewController.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo / Ilias Doukas on 19/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class LoginRegisterController: UIViewController, UITextFieldDelegate {
  
  
  let loginButton = UIButton(type: .roundedRect)
  let signUpButton = UIButton(type: .roundedRect)
  let errorLabel = UILabel()
  let usernameField = UITextField()
  let firstnameField = UITextField()
  let lastnameField = UITextField()
  let userinfoField = UITextField()
  let userpasswordField = UITextField()
  let userpwagainField = UITextField()
  
  var realm: Realm!
  var notificationToken: NotificationToken?
  let thisUser = User()
  var user: SyncUser?
  let main = UIStoryboard(name: "Main", bundle: nil)
  
  // Tänne pusketaan data --> Vaihda johonkin fiksumpaan
  private var tableSource = [] as [ChatMessage]
  
  //Log user
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    usernameField.delegate = self
    userpasswordField.delegate = self
    userinfoField.delegate = self
    userpwagainField.delegate = self
    firstnameField.delegate = self
    lastnameField.delegate = self
    
    self.usernameField.isHidden = true
    self.userpasswordField.isHidden = true
    self.userinfoField.isHidden = true
    self.userpwagainField.isHidden = true
    self.firstnameField.isHidden = true
    self.lastnameField.isHidden = true
    self.loginButton.isHidden = true
    self.signUpButton.isHidden = true
    
    // Container, can be used for additional information on the screen, is built programmatically
    let container = UIStackView()
    let messageLabel = UILabel()
    messageLabel.numberOfLines = 0
    messageLabel.text = "Please enter your credentials"
    container.addArrangedSubview(messageLabel)
    container.translatesAutoresizingMaskIntoConstraints = false
    container.axis = .vertical
    container.alignment = .fill
    container.spacing = 16.0
    view.addSubview(container)
    
    // LOGIN OR REGISTER DEPENDING ON USER
    let alertController = UIAlertController(title: "Login / Register?", message: "Login / Register?", preferredStyle: .alert)
    let toLogin = UIAlertAction(title: "Login", style: .default) {
      (action:UIAlertAction) in
      print("Pressed toLogin")
      self.usernameField.isHidden = false
      self.userpasswordField.isHidden = false
      self.loginButton.isHidden = false
    }
    let toSignUp = UIAlertAction(title: "Sign up", style: .default) {
      (action:UIAlertAction) in
      print("Pressed toSignUp")
      self.usernameField.isHidden = false
      self.userpasswordField.isHidden = false
      self.userinfoField.isHidden = false
      self.userpwagainField.isHidden = false
      self.firstnameField.isHidden = false
      self.lastnameField.isHidden = false
      self.signUpButton.isHidden = false
    }
    alertController.addAction(toLogin)
    alertController.addAction(toSignUp)
    self.present(alertController, animated: true, completion: nil)
      //SYNCUSER LOGOUT DOES NOT WORK CURRENTLY, NEEDS MORE RESEARCH, NOT A REAL LOGOUT
      //SyncUser.current?.logOut()
    
    // Create Register / Login Form
    userpwagainField.isSecureTextEntry = true
    userpasswordField.isSecureTextEntry = true
    userinfoField.frame.size.height = 100
    usernameField.placeholder = "Username"
    usernameField.borderStyle = .roundedRect
    container.addArrangedSubview(usernameField)
    firstnameField.placeholder = "First name"
    firstnameField.borderStyle = .roundedRect
    container.addArrangedSubview(firstnameField)
    lastnameField.placeholder = "Last name"
    lastnameField.borderStyle = .roundedRect
    container.addArrangedSubview(lastnameField)
    userinfoField.placeholder = "Info"
    userinfoField.borderStyle = .roundedRect
    container.addArrangedSubview(userinfoField)
    userpasswordField.placeholder = "Password"
    userpasswordField.borderStyle = .roundedRect
    container.addArrangedSubview(userpasswordField)
    userpwagainField.placeholder = "Password again"
    userpwagainField.borderStyle = .roundedRect
    container.addArrangedSubview(userpwagainField)
    // Buttons
    loginButton.setTitle("Login", for: .normal)
    loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    container.addArrangedSubview(loginButton)
    signUpButton.setTitle("Sign up", for: .normal)
    signUpButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
    container.addArrangedSubview(signUpButton)
    // Container's location on the screen
    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      container.centerXAnchor.constraint(equalTo: guide.centerXAnchor, constant: 0),
      container.centerYAnchor.constraint(equalTo: guide.centerYAnchor, constant: -100),
      
      ])
    
    
  }
  // NOT IN USE, might be used later
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destVC = segue.destination as! HomeController
    destVC.view.backgroundColor = .blue
  }
  func logIn(_ username: String,_ password: String,_ register: Bool) {
    // Check if login values are empty
    
    let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
    // Define tab bar show when logged out
    let loggedOut: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedOutTabBar") as? UITabBarController
    if usernameField.text != "" && userpasswordField.text != "" {
      RealmDB().setupRealm(username, password, register)
      print("Login as user: \(username), register \(register)")
      //Push homecontroller
      self.navigationController?.pushViewController(HomeController(), animated: true)
      self.present(loggedIn!, animated: true, completion: nil)
      return
    } else {
      // --> LOGIN FAILED, navigate to login/register page
      let alert = UIAlertController(title: "Login alert", message: "Login failed!", preferredStyle: .alert)
      let alertOk=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in print("Ok pressed")})
      alert.addAction(alertOk)
      self.present(alert, animated: true, completion: nil)
      self.present(loggedOut!, animated:  true, completion: nil)
      print("No user")
    }
  }
  
  
  
  func signUp(_ username: String, _ password: String, _ register: Bool) {
    let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
    let thisUser = User()
    thisUser.userName = username
    thisUser.firstName = firstname ?? "No first name"
    thisUser.lastName = lastname ?? "No lastname"
    thisUser.info = info ?? "No user Info"
    let credentials = SyncCredentials.usernamePassword(username: username, password: password, register: true)
    SyncUser.logIn(with: credentials, server: Constants.AUTH_URL, onCompletion: { (user, error) in
      if let user = user {
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
        // Leivotaan realmia varten asetukset. realmURL: Constants.REALM_URL --> Katso Constants.swift
        let config = user.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config)
        print("Realm connection has been setup")
        self.navigationController?.pushViewController(HomeController(), animated: true)
        self.present(loggedIn!, animated: true, completion: nil)
      }
    })
  }
  
  

  func signIn() {
    logIn(username!, password!, false)
  }
  func createUser() {
    signUp(username!, password!, true)
    
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


