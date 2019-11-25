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
  var Messages: Results<User>?
  
  // Tänne pusketaan data --> Vaihda johonkin fiksumpaan
  private var tableSource = [] as [Message]
  
  //Log user
  func logIn(_ username: String,_ password: String,_ register: Bool) {
    
    print("Login as user: \(username), register \(register)")
    // Sync credentials declaration
    let creds = SyncCredentials.usernamePassword(username: username, password: password, register: register)
    SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { (user, err) in
      if let error = err {
        print("Login error: \(error)")
        return
      }
      print("No errors")
      
    })
  }
  // Login nappi
  @IBAction func LoginButton(_ sender: UIButton!) {
    let thisUser = User()
    thisUser.name = unameLogin.text ?? ""
    // Define main storyboard
    let main = UIStoryboard(name: "Main", bundle: nil)
    // Define login storyboard
    let loginBoard = UIStoryboard(name: "LoginRegister", bundle: nil)
    let usrname: String? = thisUser.name
    let usrpw: String? = userPw.text
    let loggedInView: UIViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "homestoryboard") as UIViewController
    let loggedIn: UITabBarController? = main.instantiateViewController(withIdentifier: "LoggedInTabBar") as? UITabBarController
    if usrname != "" && usrpw != "" {
      if thisUser.name != "" {
          
          logIn(usrname ?? "", usrpw ?? "", false)
        print("\(String(describing: usrname))")
          // -> LOGIN SUCCESSFUL, navigate to LoggedIn
          
          self.present(loggedInView, animated: true, completion: nil)
          self.present(loggedIn!, animated:  true, completion: nil)
          let newMessage = Message()
          newMessage.messageSender = unameLogin.text ?? ""
          newMessage.body = "new message"
          // Ota yhteys realmiin ylläolevilla
          let realm = try! Realm()
          // Error check
          
          
          try! realm.write {
            realm.add(newMessage)
            
          }
          return
        
        
      }
      
    } else {
      // --> LOGIN FAILED, navigate to same page
      let loggedOutView: UIViewController? =
        loginBoard.instantiateViewController(withIdentifier: "logregstoryboard")
      self.present(loggedOutView!, animated: true, completion: nil)
      self.present(loggedIn!, animated:  true, completion: nil)
      print("No user")
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    unameLogin.delegate = self
    userPw.delegate = self
    
  }
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


