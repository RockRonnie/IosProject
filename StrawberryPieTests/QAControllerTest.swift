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
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        let testQAController = QAController()
        let tab = testQAController.selectedTab
        // Testataan että tabinimellä on pituutta yli 0 merkkiä
        XCTAssertTrue(tab.count > 0)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}


