//
//  Constants.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo 20/11/2019.
//  Original from Realm.io
//

import Foundation
struct Constants {
  // **** Realm Cloud Users:
  // **** Replace MY_INSTANCE_ADDRESS with the hostname of your cloud instance
  // **** e.g., "mycoolapp.us1.cloud.realm.io"
  // ****
  // ****
  // **** ROS On-Premises Users
  // **** Replace the AUTH_URL and REALM_URL strings with the fully qualified versions of
  // **** address of your ROS server, e.g.: "http://127.0.0.1:9080" and "realm://127.0.0.1:9080"
  
  // CONNECTION TO REALM
  static let MY_INSTANCE_ADDRESS = "askandreceive.de1a.cloud.realm.io" //
  
  static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
  // /~/ <-- tuolla tehdään käyttäjäkohtainen path
  static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/QATest")!

}
