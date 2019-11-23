//
//  User.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import RealmSwift

@objcMembers class User: Object {
    dynamic var userID: String = UUID().uuidString
    dynamic var userName: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var info: String = ""
    dynamic var Account_created: Date = Date()
    
    // THIS IS JUST A DUMMY VERSION. REAL ONE NEEDS TO HAVE ALL THE NECESSARY INFORMATION FOR USER PROFILE, IT ALSO NEEDS TO STORE USERS PRIVATE MESSAGES ETC.
    override static func primaryKey() -> String? {
        return "userID"
    }
  }
