//
//  User.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo / Roni Jumpponen on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// This class is used for defining a User object to be used with Realm


import RealmSwift

@objcMembers class User: Object {

    dynamic var userID: String = ""
    dynamic var userExpert: Bool = false
    dynamic var userName: String = ""
    dynamic var userEmail: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var info: String = ""
    dynamic var extraInfo: String = ""
    dynamic var uImage: String = ""
    var userInterests = List<String>()
    var userPrivateMessages = List<ChatMessage>()
    dynamic var Account_created: Date = Date()
    override static func primaryKey() -> String? {
        return "userID"
    }
}
