//
//  ExpertFeed.swift
//  StrawberryPie
//
//  Created by Joachim Grotenfelt on 27/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// This class is used for defining a ExpertFeed object to be used with Realm

import Foundation
import RealmSwift
import Foundation

@objcMembers class Feed: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var picture: String? = ""
}
