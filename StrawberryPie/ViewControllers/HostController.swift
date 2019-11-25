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
    var realm: Realm
    var objectCount = 0
    var createdSession: QASession?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //Button action
    @IBAction func createButton(_ sender: Any) {
        print("Starting the QA Session creation sequence")
        createdSession = createSession()
        print(createdSession ?? "No object")
        if let qaSession = createdSession {
            try! self.realm.write {
                self.realm.add(qaSession)
            }
        }else { print("no object")
            return
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
