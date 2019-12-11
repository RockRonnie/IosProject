//
//  QASession.swift
//  StrawberryPie
//
//  Created by iosdev on 21/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// This class is used for defining a QASession (Platform for all of the other Realm objects) object to be used with Realm


import Foundation

import RealmSwift
// Main QA SESSION OBJECT, ACTS AS A HUB FOR CONNECTING OTHER OBJECTS REQUIRED FOR TO THE SESSION SO THEY CAN BE EASILY ACCESSED.
@objcMembers class QASession: Object {
    dynamic var sessionID: String = UUID().uuidString
    dynamic var title: String = ""
    dynamic var sessionDescription: String = ""
    dynamic var sessionCategory: String = ""
    dynamic var profession: String = ""
    dynamic var education: String = ""
    dynamic var hostDescription: String = ""
    dynamic var live: Bool = false
    dynamic var upcoming: Bool = false
    dynamic var archived: Bool = false
    let host = List<User>()
    let chat = List<Chat>()
    let QABoard = List<QAMessageBoard>()
    let intro = List<Intro>()
    override static func primaryKey() -> String? {
        return "sessionID"
    }
}
