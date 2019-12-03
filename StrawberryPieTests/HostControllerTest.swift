
//  StrawberryPieTests.swift
//  StrawberryPieTests
//
//  Created by iosdev on 31/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import XCTest
@testable import StrawberryPie

class HostControllerTest: XCTestCase {
    let host = HostController()
    let realm = RealmDB.sharedInstance.realm
    override func setUp() {
        XCTAssert(realm == RealmDB.sharedInstance.realm, "Realm settings fail")
        XCTAssert(host.realm == realm, "Host Realm settings fail")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func testFields(){
        host.eduTextField.text = "derp"
        XCTAssert(host.eduTextField.text == "derp", "textfield is not correct")
        host.eduTextField.text = nil
        XCTAssert(host.eduTextField == nil, "eduText is not nil")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}


