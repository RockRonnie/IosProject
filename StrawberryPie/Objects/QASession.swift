//
//  QASession.swift
//  StrawberryPie
//
//  Created by iosdev on 21/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation
import RealmSwift
// Main QA SESSION OBJECT, ACTS AS A HUB FOR CONNECTING OTHER OBJECTS REQUIRED FOR TO THE SESSION SO THEY CAN BE EASILY ACCESSED.
@objcMembers class QASession: Object {
    dynamic var sessionID: String = UUID().uuidString
    dynamic var title: String = ""
    dynamic var sessionDescription: String = ""
    let host = List<User>()
    let chat = List<Chat>()
    let QABoard = List<QAMessageBoard>()
    let intro = List<Intro>()
    dynamic var hostDescription: String = ""
    // add properties if needed, however the objects and their data should be enough
    
    override static func primaryKey() -> String? {
        return "sessionID"
    }
    
}
