//
//  ChatMessage.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo / Ilias Doukas on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import RealmSwift

@objcMembers class Message: Object {
  
  dynamic var messageSender: String = ""
  dynamic var messageId: String = UUID().uuidString
  dynamic var body: String = ""
  dynamic var timestamp: Date = Date()
  
  
  override static func primaryKey() -> String? {
    return "messageId"
  }
  
}
