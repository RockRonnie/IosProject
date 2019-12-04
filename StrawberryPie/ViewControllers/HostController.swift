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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var eduTextField: UITextField!
    @IBOutlet weak var profTextField: UITextField!
    @IBOutlet weak var pickCategory: UIButton!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var introTextView: UITextView!
    let feed = UIStoryboard(name: "Feed", bundle: nil)
    
    
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
  
    
    var sessionTitle: String?
    var sessionIntro: String?
    var sessionDesc: String?
    var selectedCategory: String?
    var selectedProfession: String?
    var selectedEducation: String?
    
    var createdSession: QASession?
    var realm: Realm!
    var thisUser: String?
    var thisUserObject: User?
    var category = Category()
    var allCategories: Array<String> = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatabase()
        setupText()
    }
    
    //setting up Realm and CoreData
    func setupDatabase(){
        realm = RealmDB.sharedInstance.realm
        category.generateData()
        thisUser = RealmDB.sharedInstance.user?.identity ?? "Not"
        thisUserObject = RealmDB.sharedInstance.getUser()
        allCategories = category.getNames()
    }
    
    func setupText(){
        
        // setting up the textfields and username label
        usernameLabel.text = thisUserObject?.userName ?? "no name found"
        titleTextField.placeholder = "Session title"
        profTextField.placeholder = "Profession"
        eduTextField.placeholder = "Education"
        
        // Text Field/View Delegates
        titleTextField.delegate = self
        introTextView.delegate = self
        descTextView.delegate = self
        profTextField.delegate = self
        eduTextField.delegate = self
        
        // Tableview delegate / datasource / cell register methods
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PickCategoryCell.self, forCellReuseIdentifier: "Cell")
    }
    
    //Button actions for clearing the fields and creating the session
    @IBAction func clearButton(_ sender: UIButton) {
        clear()
    }
    @IBAction func createButton(_ sender: Any) {
        print("Starting the QA Session creation sequence")
        validation()
    }
    
    // clearing the fields
    func clear() {
        introTextView.text = ""
        titleTextField.text = ""
        descTextView.text = ""
        profTextField.text = ""
        eduTextField.text = ""
    }
    
    // validating the fields so that none of them is empty, creating a new session, then adding it to the global realm
    func validation(){
        if(sessionDesc != nil && sessionIntro != nil && sessionTitle != nil && selectedEducation != nil && selectedProfession != nil && selectedCategory != nil){
            sessiontoRealm()
        }else{
            let alert = UIAlertController(title: "Validation failed", message: "Please fill all the field and select a category", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated:true,completion: nil)
        }
    }
    
    // Creating the session object and sending it to realm cloud
    func sessiontoRealm() {
        let personalFeed: UIViewController? = feed.instantiateViewController(withIdentifier: "PersonalFeedController") as UIViewController
        createdSession = createSession()
        if let createdSession = createdSession {
            try! realm.write {
                realm.add(createdSession)
            }
            self.present(personalFeed!, animated:true, completion: nil)
        }
    }
    
    
    // function for making the category tableview visible
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
    
    // function for removing the transparent view (making the tableview for selecting the category invisible)
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
  
    // functions for the dropdown category menu
    @IBAction func categoryButton(_ sender: UIButton) {
        selectedButton = pickCategory
        addTransparentView(frames: pickCategory.frame)
    }

    func setCategory(category: String) {
        selectedCategory = category
    }
    
    //functions for creating the Realm objects
    func createSession() -> QASession{
        print("Creating Session object")
        let newSession = QASession(value:["title": sessionTitle ?? "session title" ,"sessionDescription": sessionDesc ?? "session description", "host": [thisUserObject] , "chat":[createChat()], "QABoard": [createBoard()], "intro": [createIntro()], "sessionCategory": selectedCategory ?? "No category", "profession": selectedProfession ?? "no profession", "education": selectedEducation ?? "no education", "upcoming":"true"])
            return newSession
    }
    func createChat() -> Chat {
        print("creatin Chat object")
        let newChat = Chat(value:["title": sessionTitle ?? "No title"])
        return newChat
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

}


extension HostController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        print("should begin editing")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        print("first responder!")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        if (textField == titleTextField){
            sessionTitle = textField.text
            if(sessionTitle != nil){
                return true
            }else{
                return false
            }
        }else if(textField == profTextField){
            selectedProfession = textField.text
            if(selectedProfession != nil){
                return true
            }else{
                return false
            }
        }else if(textField == eduTextField){
            selectedEducation = textField.text
            if(selectedEducation != nil){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        print("textfield did end editing")
       
        if (textField == titleTextField){
            if(sessionTitle != nil){
                textField.resignFirstResponder()
            }else{
                print("no title")
                textField.becomeFirstResponder()
            }
        }else if(textField == profTextField){
            if(selectedProfession != nil){
                textField.resignFirstResponder()
            }else{
                print("no profession")
                textField.becomeFirstResponder()
            }
        }else if(textField == eduTextField){
            if(selectedEducation != nil){
                textField.resignFirstResponder()
            }else{
                print("no education")
                textField.becomeFirstResponder()
            }
        }
    }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
            print("changing characters")
            return true
        } // return NO to not change text
        
        
        func textFieldShouldClear(_ textField: UITextField) -> Bool{
            return false
        } // called when clear button pressed. return NO to ignore (no notifications)
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool{
            print("returning")
            if(textField == titleTextField){
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
            }else if(textField == profTextField){
                selectedProfession = textField.text
                if (selectedProfession != ""){
                    textField.resignFirstResponder()
                    return true
                }else{
                    let alert = UIAlertController(title: "Incorrect profession", message: "Please input a proper profession", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated:true,completion: nil)
                    return false
                }
            }else if(textField == eduTextField){
                selectedEducation = textField.text
                if (selectedEducation != ""){
                    textField.resignFirstResponder()
                    return true
                }else{
                    let alert = UIAlertController(title: "Incorrect education", message: "Please input a proper education", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated:true,completion: nil)
                    return false
                }
            }else{
                return false
            }
        }
    }

extension HostController: UITextViewDelegate{
        
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
            print("should begin editing")
            return true
        } // return NO to disallow editing.
        
        func textViewDidBeginEditing(_ textView: UITextView){
            print("first responder!")
        } // became first responder
        
        func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
            print("TextView should end editing")
            if (textView == introTextView){
                sessionIntro = textView.text
                if(sessionIntro != nil){
                    return true
                }else{
                return false
                }
            }else if(textView == descTextView){
                sessionDesc = textView.text
                if(sessionDesc != nil){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        }// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end1
        
        func textViewDidEndEditing(_ textView: UITextView){
            print("textfield did end editing")

            if (textView == introTextView){
                if(sessionIntro != nil){
                    textView.resignFirstResponder()
                }else{
                    print("no intro")
                    textView.becomeFirstResponder()
                }
            }else if(textView == descTextView){
                if(sessionIntro != nil){
                    textView.resignFirstResponder()
                }else{
                    print("no description")
                    textView.becomeFirstResponder()
                }
            }
        }
            func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
                print("changing characters")
                return true
            } // return NO to not change text
            
            
            func textViewShouldClear(_ textView: UITextView) -> Bool{
                return false
            } // called when clear button pressed. return NO to ignore (no notifications)
            
            func textViewShouldReturn(_ textView: UITextView) -> Bool{
                print("returning")
                if(textView == introTextView){
                    sessionIntro = textView.text
                    if (sessionIntro != ""){
                        textView.resignFirstResponder()
                        return true
                    }else{
                        let alert = UIAlertController(title: "Incorrect intro", message: "Please input a proper session intro", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated:true,completion: nil)
                        return false
                    }
                }else if(textView == descTextView){
                    sessionDesc = textView.text
                    if (sessionDesc != ""){
                        textView.resignFirstResponder()
                        return true
                    }else{
                        let alert = UIAlertController(title: "Incorrect description", message: "Please input a proper session description", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated:true,completion: nil)
                        return false
                    }
                }else{
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
        setCategory(category: allCategories[indexPath.row])
        selectedButton.setTitle(allCategories[indexPath.row], for: .normal)
        removeTransparentView()
    }
}
