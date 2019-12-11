//
//  ChatMessage.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo / Ilias Doukas on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// // This class is used for defining a ChatMessage object to be used with Realm


import RealmSwift

@objcMembers class ChatMessage: Object {
    // Poista messageSender Realmiä uudelleenluotaessa
    dynamic var messageSender = ""
    dynamic var messageUser = List<User>()
    dynamic var messageId: String = UUID().uuidString
    dynamic var body: String = ""
    dynamic var timestamp: Date = Date()
  override static func primaryKey() -> String? {
    return "messageId"
  }
}
