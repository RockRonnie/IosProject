//
//  RealmDB.swift
//  StrawberryPie
//
//  Created by iosdev on 25/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDB {
    var realm:Realm!
    var user: SyncUser?
    var setup = false
    
    static let sharedInstance = RealmDB()
   /*
  func setupRealm(_ username: String,_ password: String,_ register: Bool) {
        // Yritä kirjautua sisään --> Vaihda kovakoodatut tunnarit pois
        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: Constants.AUTH_URL) { user, error in
            if let user = user {
                // Onnistunut kirjautuminen
                // Lähetetään permission realmille -> read/write oikeudet käytössä olevalle palvelimelle. realmURL: Constants.REALM_URL --> Katso Constants.swift
                let permission = SyncPermission(realmPath: Constants.REALM_URL.absoluteString, username: "\(username)", accessLevel: .write)
                user.apply(permission, callback: { (error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "No error")
                    } else {
                        print("success")
                    }
                })
                self.user = user
                let admin = user.isAdmin
                print(admin)
                // Leivotaan realmia varten asetukset. realmURL: Constants.REALM_URL --> Katso Constants.swift
                let config = user.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
                self.realm = try! Realm(configuration: config)
                print("Realm connection has been setup")
            } else if let error = error {
              print("Login error: \(error)")
          }
        }
    }
    */
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
