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
  
  @IBOutlet weak var unameLogin: UITextField!
  @IBOutlet weak var userPw: UITextField!
  
  let signInButton = UIButton(type: .roundedRect)
  let signUpButton = UIButton(type: .roundedRect)
  let errorLabel = UILabel()
  
  var realm: Realm!
  var notificationToken: NotificationToken?
  let thisUser = User()
  let main = UIStoryboard(name: "Main", bundle: nil)
  
  // Tänne pusketaan data --> Vaihda johonkin fiksumpaan
  private var tableSource = [] as [ChatMessage]
  
  //Log user
  func logIn(_ username: String,_ password: String,_ register: Bool) {
    RealmDB().setupRealm(username, password, register)
    print("Login as user: \(username), register \(register)")
        //Push homecontroller
    self.navigationController?.pushViewController(HomeController(), animated: true)
        return
  }

        //self.navigationController?.pushViewController(LoginRegisterController(), animated: true)
  @IBAction func SignupButton(_ sender: UIButton!) {
    let loggedIn: UITabBarController? = self.main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
    self.present(loggedIn!, animated:  true, completion: nil)
  }
  // Login nappi
  @IBAction func LoginButton(_ sender: UIButton!) {
    
    logIn(unameLogin.text ?? "", userPw.text ?? "", false)
    let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
    // Define tab bar show when logged out
    let loggedOut: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedOutTabBar") as? UITabBarController
    // Check if login values are empty
    if unameLogin.text != "" && userPw.text != ""
    {
      print("\(String(describing: username))")
      // LOGIN SUCCESSFUL, navigate to home and show loggedIn tabbar
      self.present(loggedIn!, animated:  true, completion: nil)
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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    unameLogin.delegate = self
    userPw.delegate = self
        // Container, can be used for additional information on the screen, is built programmatically
    let container = UIStackView()
    let messageLabel = UILabel()
    messageLabel.numberOfLines = 0
    messageLabel.text = "Please enter your credentials"
    container.addArrangedSubview(messageLabel)
    container.translatesAutoresizingMaskIntoConstraints = false
    container.axis = .horizontal
    container.alignment = .fill
    container.spacing = 16.0
    view.addSubview(container)
    // Container's location on the screen
    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      container.centerXAnchor.constraint(equalTo: guide.centerXAnchor, constant: 0),
      container.centerYAnchor.constraint(equalTo: guide.centerYAnchor, constant: -300),
      
      ])
    
    
  }
  // NOT IN USE, might be used later
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destVC = segue.destination as! HomeController
    destVC.view.backgroundColor = .blue
  }
  
  var username: String? {
    get {
      return unameLogin.text
    }
  }
  var password: String? {
    get {
      return userPw.text
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


