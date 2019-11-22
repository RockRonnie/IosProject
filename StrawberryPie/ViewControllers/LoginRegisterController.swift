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
  
  //Log user
  func logIn(_ username: String,_ password: String,_ register: Bool) {
    
    print("Login as user: \(username), register \(register)")
    // Sync credentials declaration
    let creds = SyncCredentials.usernamePassword(username: username, password: password, register: register)
    SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { (user, err) in
      // Error check
      if let error = err {
        print("Login error: \(error)")
        return
      }
      print("No errors")
      
    })
  }
  // Login nappi
  @IBAction func LoginButton(_ sender: UIButton!) {
    // Define main storyboard
    let main = UIStoryboard(name: "Main", bundle: nil)
    // Define login storyboard
    let loginBoard = UIStoryboard(name: "LoginRegister", bundle: nil)
    let usrname: String? = unameLogin.text
    let usrpw: String? = userPw.text
    if usrname != "" && usrpw != "" {
      if SyncUser.current != nil {
        if let user = SyncUser.current {
          logIn(usrname ?? "", usrpw ?? "", false)
          print("\(user)")
          // -> LOGIN SUCCESSFUL, navigate to LoggedIn
          let loggedInView: HomeController? =
            loginBoard.instantiateViewController(withIdentifier: "homestoryboard") as? HomeController
          let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
          self.present(loggedInView!, animated: true, completion: nil)
          self.present(loggedIn!, animated:  true, completion: nil)
          return
        }
      }
    }
    // --> LOGIN FAILED, navigate to same page
    let loggedInView: UIViewController? =
      loginBoard.instantiateViewController(withIdentifier: "logregstoryboard")
    self.present(loggedInView!, animated: true, completion: nil)
    let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedOutTabBar") as? UITabBarController
    self.present(loggedIn!, animated:  true, completion: nil)
    print("No user")
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
}


