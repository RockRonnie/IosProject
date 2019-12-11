//
//  File.swift
//  StrawberryPie
//
//  Created by iosdev on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// // This class is used for defining a QA (Question and Answer) object to be used with Realm


import Foundation
import RealmSwift
@objcMembers class QA: Object{
    dynamic var QAID: String = UUID().uuidString
    let question = List<ChatMessage>()
    let answer = List<ChatMessage>()
    override static func primaryKey() -> String? {
    return "QAID"
    }
}
