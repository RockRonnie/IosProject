//
//  LoginRegisterTest.swift
//  StrawberryPieTests
//
//  Created by iosdev on 06/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import XCTest
@testable import StrawberryPie

class LoginRegisterTest: XCTestCase {
  let logreg = LoginRegisterController()

    override func setUp() {
      
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      logreg.firstnameField.text = ""
      logreg.lastnameField.text = ""
      logreg.userOccupation.text = ""
      logreg.userXtraInfoField.text = ""
    }

    func testExample() {
      logreg.firstnameField.text = "TestFirstname"
      logreg.lastnameField.text = "TestLastname"
      logreg.userOccupation.text = "Plumber"
      logreg.userXtraInfoField.text = "Xtra info"
      XCTAssert(logreg.firstname == "TestFirstname", "Wrong first name, is not TestFirstname")
      XCTAssert(logreg.lastname == "TestLastname", "Wrong last name, is not TestLastname")
      XCTAssert(logreg.info == "Info", "Wrong info")
      logreg.user = nil
      XCTAssert(logreg.user == nil, "User is nil, does not exist")

    
  }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
