//
//  Intro.swift
//  StrawberryPie
//
//  Created by iosdev on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation

import RealmSwift
// intro object for QA session
@objcMembers class Intro: Object {
    dynamic var introId: String = UUID().uuidString
    dynamic var title: String = ""
    dynamic var body: String = ""
    // possibility of creating several chapters to make the text flow better? for now just one body will do
    dynamic var sessionAdded: Date = Date()
    override static func primaryKey() -> String? {
        return "introId"
    }
    
}
