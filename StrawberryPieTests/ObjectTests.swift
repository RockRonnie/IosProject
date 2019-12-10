//
//  ObjectTests.swift
//  StrawberryPieTests
//
//  Created by iosdev on 10/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation
import XCTest
@testable import StrawberryPie

class ObjectTests: XCTestCase {
    
    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    func sessionTest(){
        
    }
    func chatMessageTest(){
        let testMessage = ChatMessage()
        XCTAssert(testMessage.body == "", "body is derp")
        let user = User()
        let body = "test2"
        testMessage.body = "test"
        XCTAssert(testMessage.body == "test", "Testmessage is not correct")
        testMessage.body = body
        XCTAssert(testMessage.body == body, "Testmessage2 is not correct")
        testMessage.messageUser.append(user)
        XCTAssert(testMessage.messageUser.count == 1, "testmessage user object count is not correct")
        XCTAssert(testMessage.messageUser[0] == user, "testmessage user doesnt match the user object")
    }
    func chatTest(){
        let testChat = Chat()
        let testMessage = ChatMessage()
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
