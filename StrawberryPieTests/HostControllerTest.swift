
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
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func testFields(){
        //edu
    
        host.selectedEducation = "derp"
        XCTAssert(host.selectedEducation == "derp", "selected education is not derp")
        host.selectedEducation = nil
        XCTAssert(host.selectedEducation == nil, "selected education is not nill")
        
        //prof
        host.selectedProfession = "prof"
        XCTAssert(host.selectedProfession == "prof", "selected profession is not prof")
        host.selectedProfession = nil
        XCTAssert(host.selectedProfession == nil, "selected profession is not nill")
        
        //title
       
        host.sessionTitle = "title"
        XCTAssert(host.sessionTitle == "title", "selected title is not title")
      
        host.sessionTitle = nil
        XCTAssert(host.sessionTitle == nil, "selected title is not nill")
        
        //desc
        
        host.sessionDesc = "desc"
        XCTAssert(host.sessionDesc == "desc", "selected desc is not desc")
        
        host.sessionDesc = nil
        XCTAssert(host.sessionDesc == nil, "selected desc is not nill")
        
        //intro
   
        host.sessionIntro = "intro"
        XCTAssert(host.sessionIntro == "intro", "selected intro is not intro")
       
        host.sessionIntro = nil
        XCTAssert(host.sessionIntro == nil, "selected intro is not nill")
 
    }
    
    func testFunctions(){
        host.setCategory(category: "Halp")
        XCTAssert(host.selectedCategory == "Halp", "Host category not set to Halp")
        let categories = host.allCategories
        XCTAssert(categories == [], "All categories is not an empty array")
    }
    func realmTests(){
        let intro = host.createIntro()
        let secondintro = host.createIntro()
        XCTAssert(intro != secondintro , "Intro is not unique")
        let chat = host.createChat()
        let chat2 = host.createChat()
        XCTAssert(chat != chat2, "Chat is not unique")
        let board = host.createBoard()
        let board2 = host.createBoard()
        XCTAssert(board != board2, "Board is not unique")
        let session = host.createSession()
        let session2 = host.createSession()
        XCTAssert(session != session2, "session is not unique")
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


