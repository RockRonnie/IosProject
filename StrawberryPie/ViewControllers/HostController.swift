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
    var objectCount = 0
    var createdSession: QASession?
    var realm: Realm!
    var thisUser: String?
    
    override func viewDidLoad() {
        realm = RealmDB.sharedInstance.realm
        print(RealmDB.sharedInstance.user?.isAdmin ?? "this sucks")
        print(RealmDB.sharedInstance.user?.identity ?? "huoh")
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        
    }
    //Button action
    @IBAction func clearButton(_ sender: UIButton) {
        introTextView.text = ""
        titleField.text = ""
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
    
    //functions for creating the objects
    func createSession() -> QASession{
        print("Creating Session object")
        let newSession = QASession(value:["title": "Session number \(objectCount)","sessionDescription": "Session description for session number \(objectCount)", "host": [createUser()], "chat":[createChat()], "QABoard": [createBoard()], "intro": [createIntro()]])
        return newSession
    }
    func createChat() -> Chat {
        print("creatin Chat object")
        let newChat = Chat(value:["title": "chat number \(objectCount)"])
        return newChat
    }
    func createUser() -> User {
        print("Creating a user object to serve as a host")
        let newUser = User(value:["userName": "user\(objectCount)", "firstName": "firstname user\(objectCount)", "lastName": "lastname user\(objectCount)", "info": "info for user \(objectCount)"])
        return newUser
    }
    func createIntro() -> Intro {
        print("Creating Session Intro object")
        let newIntro = Intro(value: ["title": "This is intro number \(objectCount)", "body": "This is the story of object number \(objectCount)"])
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

/*
extension HostController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        print("Should I?")
        return true
    } // return NO to disallow editing.
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        print("first responder!")
    } // became first responder
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        pickedName = textField.text
        print("Textfield should end editing")
        if(pickedName != nil){
            return true
        }else{
            return false
        }
    }// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end1
    
    func textFieldDidEndEditing(_ textField: UITextField){
        print("textfield did end editing")
        if(pickedName != nil){
            textField.resignFirstResponder()
        }else{
            print("no name selected")
            textField.becomeFirstResponder()
        }
} // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
 
 
    extension HostController: UITextViewDelegate {
        
        func textFieldShouldBeginEditing(_ textField: UITextView) -> Bool{
            print("Should I?")
            return true
        } // return NO to disallow editing.
        
        func textFieldDidBeginEditing(_ textField: UITextView){
            print("first responder!")
        } // became first responder
        
        func textFieldShouldEndEditing(_ textField: UITextView) -> Bool{
            pickedName = textField.text
            print("Textfield should end editing")
            if(pickedName != nil){
                return true
            }else{
                return false
            }
        }// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end1
        
        func textFieldDidEndEditing(_ textField: UITextView){
            print("textfield did end editing")
            if(pickedName != nil){
                textField.resignFirstResponder()
            }else{
                print("no name selected")
                textField.becomeFirstResponder()
            }
}
*/
