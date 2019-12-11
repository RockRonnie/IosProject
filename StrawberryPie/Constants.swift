//
//  Constants.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo 20/11/2019.
//  Original from Realm.io
//
// Constant addresses for Realm Connection

import Foundation
struct Constants {
  
  // CONNECTION TO REALM
  static let MY_INSTANCE_ADDRESS = "askandreceive.de1a.cloud.realm.io" //
  
  static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
  // /~/ <-- tuolla tehdään käyttäjäkohtainen path
  static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/QANew")!
  

}
