//
//  User.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo / Roni Jumpponen on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import RealmSwift

// User class, work in progress
@objcMembers class User: Object {

    dynamic var userID: String = ""
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
