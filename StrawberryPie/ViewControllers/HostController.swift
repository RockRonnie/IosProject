//
//  HostController.swift
//  StrawberryPie
//
//  Created by iosdev on 23/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift


class HostController: UIViewController {
    @IBOutlet weak var pickCategory: UIButton!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var titleField: UITextField!
    
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    
    var sessionTitle: String?
    var sessionIntro: String?
    var objectCount = 0
    var createdSession: QASession?
    var realm: Realm!
    var thisUser: String?
    var thisUserObject: User?
    var category = Category()
    var allCategories: Array<String> = []
    var selectedCategory: String = ""
    var selectedView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = RealmDB.sharedInstance.realm
        category.generateData()
        print(RealmDB.sharedInstance.user?.isAdmin ?? "this sucks")
        print(RealmDB.sharedInstance.user?.identity ?? "huoh")
        thisUser = RealmDB.sharedInstance.user?.identity ?? "Not"
        thisUserObject = RealmDB.sharedInstance.getUser()
        allCategories = category.getNames()
        usernameLabel.text = thisUserObject?.userName ?? "no name found"
        print(allCategories)
        titleField.delegate = self
        introTextView.delegate = self
        descTextView.delegate = self
        
        // Tableview delegate / datasource / cell register methods
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PickCategoryCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.allCategories.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
  
    //Button actions
    @IBAction func clearButton(_ sender: UIButton) {
        introTextView.text = ""
        titleField.text = ""
        descTextView.text = ""
    }
    @IBAction func createButton(_ sender: Any) {
        print("Starting the QA Session creation sequence")
        createdSession = createSession()
        print(createdSession ?? "No object")
        if let createdSession = createdSession {
            try! realm.write {
                realm.add(createdSession)
            }
        }
        objectCount += 1
    }
    @IBAction func categoryButton(_ sender: UIButton) {
        selectedButton = pickCategory
        addTransparentView(frames: pickCategory.frame)
    }
    
    // functions for the dropdown category menu
    func setCategory(category: String) {
        selectedCategory = category
    }
    
    func setText(_ sender: UITextView){
        
    }
    
    //functions for creating the Realm objects
    func createSession() -> QASession{
        print("Creating Session object")
        let newSession = QASession(value:["title": sessionTitle ?? "session title" ,"sessionDescription": sessionTitle ?? "session description", "host": [thisUserObject] , "chat":[createChat()], "QABoard": [createBoard()], "intro": [createIntro()], "category": selectedCategory])
            return newSession
    }
    func createChat() -> Chat {
        print("creatin Chat object")
        let newChat = Chat(value:["title": sessionTitle ?? "No title"])
        return newChat
    }
    /*
    func createUser() -> User? {
        print("Creating a user object to serve as a host")
            let newUser = User(value:["userID": thisUser ?? "dummyuser" ,"userName": "user\(objectCount)", "firstName": "firstname user\(objectCount)", "lastName": "lastname user\(objectCount)", "info": "info for user \(objectCount)"])
            return newUser
    }
     */

    func getUser(){
            let foundUser = self.realm.objects(User.self).filter("userID = %@", thisUser ?? "thisone").first
            self.thisUserObject = foundUser
    }
    func createIntro() -> Intro {
        print("Creating Session Intro object")
        let newIntro = Intro(value: ["title": sessionTitle ?? "Session Title", "body": sessionIntro ?? "Session intro"])
        return newIntro
    }
    func createBoard() -> QAMessageBoard {
        print("Creating message board object")
        let newBoard = QAMessageBoard()
        return newBoard
    }
    
    
    // initializing a realm object
    // (value: ["brand": "BMW", "year": 1980])
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension HostController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        print("should begin editing")
        return true
    } // return NO to disallow editing.
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        print("first responder!")
    } // became first responder
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        sessionTitle = textField.text
        print("Textfield should end editing")
        if(sessionTitle != nil){
            return true
        }else{
            return false
        }
    }// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end1
    
    func textFieldDidEndEditing(_ textField: UITextField){
        print("textfield did end editing")
        if(sessionTitle != nil){
            textField.resignFirstResponder()
        }else{
            print("no name selected")
            textField.becomeFirstResponder()
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
            print("changing characters")
            let allowedCharacters = CharacterSet.letters
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } // return NO to not change text
        
        
        func textFieldShouldClear(_ textField: UITextField) -> Bool{
            return false
        } // called when clear button pressed. return NO to ignore (no notifications)
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool{
            print("returning")
            sessionTitle = textField.text
            if (sessionTitle != ""){
                textField.resignFirstResponder()
                return true
            }else{
                let alert = UIAlertController(title: "Incorrect title", message: "Please input a proper session title", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated:true,completion: nil)
                return false
            }
            
        } // called when 'return' key pressed. return NO to ignore.
    }
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
extension HostController: UITextViewDelegate{
        
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
            print("should begin editing")
            return true
        } // return NO to disallow editing.
        
        func textViewDidBeginEditing(_ textView: UITextView){
            print("first responder!")
        } // became first responder
        
        func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
            sessionIntro = textView.text
            print("Textfield should end editing")
            if(sessionIntro != nil){
                return true
            }else{
                return false
            }
        }// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end1
        
        func textViewDidEndEditing(_ textView: UITextView){
            print("textfield did end editing")
            if(sessionIntro != nil){
                textView.resignFirstResponder()
            }else{
                print("no name selected")
                textView.becomeFirstResponder()
            }
    }
            func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
                print("changing characters")
                let allowedCharacters = CharacterSet.letters
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet)
            } // return NO to not change text
            
            
            func textViewShouldClear(_ textView: UITextView) -> Bool{
                return false
            } // called when clear button pressed. return NO to ignore (no notifications)
            
            func textViewShouldReturn(_ textView: UITextView) -> Bool{
                print("returning")
                sessionTitle = textView.text
                if (sessionTitle != ""){
                    textView.resignFirstResponder()
                    return true
                }else{
                    let alert = UIAlertController(title: "Incorrect title", message: "Please input a proper session title", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated:true,completion: nil)
                    return false
                }
                
            } // called when 'return' key pressed. return NO to ignore.
}
extension HostController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = allCategories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(allCategories[indexPath.row], for: .normal)
        setCategory(category: allCategories[indexPath.row])
        removeTransparentView()
    }
}
