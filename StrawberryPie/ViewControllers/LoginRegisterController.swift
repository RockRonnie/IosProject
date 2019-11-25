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
  
  var realm: Realm!
  var notificationToken: NotificationToken?
  var Messages: Results<Message>?
  let thisUser = User()

  // Tänne pusketaan data --> Vaihda johonkin fiksumpaan
  private var tableSource = [] as [Message]
  
  //Log user
  func logIn(_ username: String,_ password: String,_ register: Bool) {
    
    print("Login as user: \(username), register \(register)")
    // Sync credentials declaration and login
    let creds = SyncCredentials.usernamePassword(username: username, password: password, register: register)
    SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { (user, err) in
      if let error = err {
        print("Login error: \(error)")
        self.navigationController?.pushViewController(LoginRegisterController(), animated: true)
        return
      } else if user != nil{
      print("No errors")
      // set username
        self.thisUser.userName = username
        print(self.thisUser.userName)
      //Push homecontroller
      self.navigationController?.pushViewController(HomeController(), animated: true)
      }
    })
  }
  // Login nappi
  @IBAction func LoginButton(_ sender: UIButton!) {
    // Define main Tab bar controller
    let main = UIStoryboard(name: "Main", bundle: nil)
    // Define login storyboard
    //let loginBoard = UIStoryboard(name: "LoginRegister", bundle: nil)
    // Get username and pw from Loginscreen
    let usrname: String? = unameLogin.text
    let usrpw: String? = userPw.text
    // Define tab bar shown when logged in
    let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
    // Define tab bar show when logged out
    let loggedOut: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedOutTabBar") as? UITabBarController
    // Check if login values are empty
    if usrname != "" && usrpw != "" && SyncUser.current != nil {
      
      logIn(usrname ?? "", usrpw ?? "", false)
      print("\(String(describing: usrname))")
      //---- NOT IN USE ----> //
      //let loggedInView: UIViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "homestoryboard") as UIViewController
      
      //self.present(loggedInView, animated: true, completion: nil)
      // <--- NOT IN USE ---- //
      
      // LOGIN SUCCESSFUL, navigate to home and show loggedIn tabbar
      self.present(loggedIn!, animated:  true, completion: nil)
      
      // Some placeholder realm data
      let newUser = User()
      newUser.userName = usrname!
      let newMessage = Message()
      newMessage.messageSender = "Maketest"
      newMessage.body = "new message"
      // Connection to realm
      // Error check
      
      // Some placeholder realm writes
      //try! self.realm.write {
      //  self.realm.add(newMessage)
        
      //}
      return
      
      
      
      
    } else {
      // -- NOT IN USE --> //
      //let loggedOutView: UIViewController? = loginBoard.instantiateViewController(withIdentifier: "logregstoryboard")
      //self.present(loggedOutView!, animated: true, completion: nil)
      // <-- NOT IN USE --- //
      
      // --> LOGIN FAILED, navigate to same page
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
    
  }
  // NOT IN USE
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destVC = segue.destination as! HomeController
    destVC.view.backgroundColor = .blue
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


