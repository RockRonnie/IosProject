//
//  QAMessageBoard.swift
//  StrawberryPie
//
//  Created by iosdev on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// This class is used for defining a QAMessageBoard object to be used with Realm. QAMessageBoard contains a list of
// all the question and answer pairs of the session


import Foundation
import RealmSwift

@objcMembers class QAMessageBoard: Object {
    dynamic var boardID: String = UUID().uuidString
    let QAs = List<QA>()
    override static func primaryKey() -> String? {
        return "boardID"
    }
}
