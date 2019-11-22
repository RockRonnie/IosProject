//
//  ViewController.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo on 19/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class LoginRegisterController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var unameLogin: UITextField!
  @IBOutlet weak var userPw: UITextField!
  
  func logIn(_ username: String,_ password: String,_ register: Bool) {
    print("Login as user: \(username), register \(register)")
    let creds = SyncCredentials.usernamePassword(username: username, password: password, register: register)
    SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { (user, err) in if let error = err {
      print("Login error: \(error)")
      return
      }
      print("Login succesful!")
    })
  }
  
  @IBAction func LoginButton(_ sender: UIButton!) {
    let main = UIStoryboard(name: "Main", bundle: nil)
    let usrname: String? = unameLogin.text
    let usrpw: String? = userPw.text
    logIn(usrname ?? "", usrpw ?? "", false)
    if (SyncUser.current != nil) {
      let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
      
      self.present(loggedIn!, animated:  true, completion: nil)
    } else {
      print("Not logged in!")
    }
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    unameLogin.delegate = self
    userPw.delegate = self
    
  }
  func signIn() {
    logIn(username!, password!, false)
  }
  func signUp() {
    logIn(username!, password!,
          false)
  }
}
