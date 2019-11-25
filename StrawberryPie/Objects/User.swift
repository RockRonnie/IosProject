//
//  User.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import RealmSwift

// User class, work in progress
@objcMembers class User: Object {
  dynamic var userId: String = UUID().uuidString
  dynamic var userName: String = ""
  

  }
