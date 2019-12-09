//
//  PrivateChat.swift
//  StrawberryPie
//
//  Created by iosdev on 08/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class PrivateChat: Object {
    dynamic var privatechatID: String = UUID().uuidString
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
    
    // add properties if needed, however the objects and their data should be enough
    
    override static func primaryKey() -> String? {
        return "sessionID"
    }
    
}
