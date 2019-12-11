//
//  RealmUtility.swift
//  StrawberryPie
//
//  Created by iosdev on 11/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
//This class contains tools for Realm functions

import Foundation
import RealmSwift

class RealmUtility {
    private var realm: Realm
    private var users: List<User>?
    private var sessionTitle: String?
    private var sessionIntro: String?
    init(){
        realm = RealmDB.sharedInstance.realm
    }
    
    func checkIfChatExists(_ users: List<User>) -> Chat{
        print("checking if chat exists")
        self.users = users
        print(users)
        let result = realm.objects(Chat.self).filter("ANY userList.userID = %@", users[0].userID).filter("ANY userList.userID = %@", users[1].userID).first
        print(result)
        if let result = result {
            print("found a chat for these two buggers")
            let myChat = result
            return myChat
        }
        else{
            print("creating a new chat")
            let myTitle = "Private chat for \(users[0].userName) and \(users[1].userName)"
            let myChat = createPrivateChat(myTitle, users)
            try! realm.write {
                realm.add(myChat)
            }
            
            return myChat
        }
    }

    func createPrivateChat (_ title: String, _ users: List<User>) -> Chat {
        print("creatin Chat object")
        let newChat = Chat(value:["title": title, "userList": users])
        return newChat
    }
    
    func createChat(_ title: String) -> Chat {
        print("creatin Chat object")
        let newChat = Chat(value:["title": title])
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
