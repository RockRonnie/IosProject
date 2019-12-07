//
//  StrawberryPieTests.swift
//  StrawberryPieTests
//
//  Created by iosdev on 31/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import XCTest
@testable import StrawberryPie

class QAControllerTest: XCTestCase {
    let testQAController = QAController()
//    let testSession = QASession()
//    let testHost = User()
//    let testChat = Chat()
//    let testQABoard = QAMessageBoard()
//    let testIntro = Intro()
    

    
    override func setUp() {
//        testSession.title = "Test title"
//        testSession.sessionDescription = "Test description"
//        testSession.sessionCategory = "Natural Sciences"
//        testSession.live = false
//        testSession.upcoming = true
//        testSession.archived = false
//        testSession.profession = "Tester"
//        testSession.education = "Testing school"
//
//        testSession.host = testHost
//        testSession.chat = testChat
//        testSession.QABoard = testQABoard
//        testSession.intro = testIntro
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func areThereSources() {
//        testQAController.populateSources()
//        XCTAssertTrue(testQAController.chatSource?.count ?? 0 > 0)
//
        
    }
    
    func isTabSelected() {
        let tab = testQAController.selectedTab
        // Testataan että tabinimellä on pituutta yli 0 merkkiä
        XCTAssertTrue(tab.count > 0)
    }
    func defaultTab() {
        let tab = testQAController.selectedTab
        XCTAssertEqual(tab, "topic")
        
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}


