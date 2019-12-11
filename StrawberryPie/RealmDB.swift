//
//  RealmDB.swift
//  StrawberryPie
//
//  Created by iosdev on 25/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// Singleton class for creating a common Realm conection for all parts of the application.

import Foundation
import RealmSwift

class RealmDB {
    var realm:Realm!
    var user: SyncUser?
    var setup = false
    static let sharedInstance = RealmDB()
    func getUser() -> User? {
        let userObject = self.realm.objects(User.self).filter("userID = %@", user?.identity ?? "default").first
        return userObject
    }
   
    func addData(object: Object)   {
        try! realm.write {
            realm.add(object)
            print("Added new object")
        }
    }
    
    func deleteAllFromDatabase()  {
        try!   realm.write {
            realm.deleteAll()
        }
    }
    
    func deleteFromDb(object: Object)   {
        try! realm.write {
            realm.delete(object)
        }
    }
}
