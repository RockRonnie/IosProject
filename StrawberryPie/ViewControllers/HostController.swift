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
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var titleField: UITextField!
    var sessionTitle: String?
    var sessionIntro: String?
    var objectCount = 0
    var createdSession: QASession?
    var realm: Realm!
    var thisUser: String?
    var thisUserObject: User?
    
    override func viewDidLoad() {
        realm = RealmDB.sharedInstance.realm
        print(RealmDB.sharedInstance.user?.isAdmin ?? "this sucks")
        print(RealmDB.sharedInstance.user?.identity ?? "huoh")
        thisUser = RealmDB.sharedInstance.user?.identity ?? "Not"
        usernameLabel.text = thisUser
        
        super.viewDidLoad()
        titleField.delegate = self
        introTextView.delegate = self
      
    }
  
    //Button action
    @IBAction func clearButton(_ sender: UIButton) {
        introTextView.text = ""
        titleField.text = ""
    }
    @IBAction func createButton(_ sender: Any) {
        getUser()
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
    
    //functions for creating the objects
    func createSession() -> QASession{
        print("Creating Session object")
            let newSession = QASession(value:["title": sessionTitle ?? "session title" ,"sessionDescription": sessionTitle ?? "session description", "host": [thisUserObject], "chat":[createChat()], "QABoard": [createBoard()], "intro": [createIntro()]])
            return newSession
    }
    func createChat() -> Chat {
        print("creatin Chat object")
        let newChat = Chat(value:["title": sessionTitle])
        return newChat
    }
    func createUser() -> User? {
        print("Creating a user object to serve as a host")
            let newUser = User(value:["userID": thisUser ?? "dummyuser" ,"userName": "user\(objectCount)", "firstName": "firstname user\(objectCount)", "lastName": "lastname user\(objectCount)", "info": "info for user \(objectCount)"])
            return newUser
    }

    func getUser(){
            let foundUser = self.realm.objects(User.self).filter("userID = self.thisUser").first
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
    /*
    func getSession() -> QASession {
            let realmSession = realm.objects(QASession.self).sorted(byKeyPath: "sessionID", ascending: false)
        return realmSession[0]
    }
 */
    // Initializing a realm object
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
