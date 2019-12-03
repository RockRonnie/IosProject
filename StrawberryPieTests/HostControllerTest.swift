
//  StrawberryPieTests.swift
//  StrawberryPieTests
//
//  Created by iosdev on 31/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import XCTest
@testable import StrawberryPie

class HostControllerTest: XCTestCase {
    let home = HomeController()
    let host = HostController()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func testFields(){
        //edu
        /*
        host.eduTextField.text = "edu"
        XCTAssert(host.eduTextField.text == "edu", "edu textfield is not correct")
        host.selectedEducation = host.eduTextField.text
        XCTAssert(host.selectedEducation == host.eduTextField.text, "selected education is not derp like edu,text")
        host.eduTextField.text = nil
        XCTAssert(host.eduTextField == nil, "eduText is not nil")
        host.selectedEducation = host.eduTextField.text
        XCTAssert(host.selectedEducation == host.eduTextField.text, "selected education is not nill like edu.text")
        
        //prof
        host.profTextField.text = "prof"
        XCTAssert(host.profTextField.text == "pro", "prof textfield is not correct")
        host.selectedEducation = host.eduTextField.text
        XCTAssert(host.selectedProfession == host.profTextField.text, "selected profession is not pro like prof.text")
        host.profTextField.text = nil
        XCTAssert(host.profTextField == nil, "profText is not nil")
        host.selectedProfession = host.eduTextField.text
        XCTAssert(host.selectedProfession == host.eduTextField.text, "selected profession is not nill like prof.text")
        
        //title
        host.titleTextField.text = "title"
        XCTAssert(host.profTextField.text == "title", "title textfield is not correct")
        host.sessionTitle = host.titleTextField.text
        XCTAssert(host.sessionTitle == host.titleTextField.text, "selected title is not title like title.text")
        host.titleTextField.text = nil
        XCTAssert(host.titleTextField == nil, "titleText is not nil")
        host.sessionTitle = host.titleTextField.text
        XCTAssert(host.sessionTitle == host.titleTextField.text, "selected title is not nill like title.text")
        
        //desc
        host.descTextView.text = "desc"
        XCTAssert(host.descTextView.text == "desc", "desc textview is not correct")
        host.sessionDesc = host.descTextView.text
        XCTAssert(host.sessionDesc == host.descTextView.text, "selected desc is not desc like desc.text")
        host.descTextView.text = nil
        XCTAssert(host.descTextView == nil, "descText is not nil")
        host.sessionDesc = host.descTextView.text
        XCTAssert(host.sessionDesc == host.descTextView.text, "selected desc is not nill like the desc.text")
        
        //intro
        host.introTextView.text = "intro"
        XCTAssert(host.introTextView.text == "intro", "intro textview is not correct")
        host.sessionIntro = host.introTextView.text
        XCTAssert(host.sessionIntro == host.introTextView.text, "selected intro is not intro like intro.text")
        host.introTextView.text = nil
        XCTAssert(host.introTextView == nil, "introText is not nil")
        host.sessionIntro = host.introTextView.text
        XCTAssert(host.sessionIntro == host.introTextView.text, "selected intro is not nill like the intro.text")
        */
    }
    
    func testFunctions(){
        host.setCategory(category: "Halp")
        XCTAssert(host.selectedCategory == "Halp", "Host category not set to Halp")
        let categories = host.allCategories
        /*
        host.setupDatabase()
        XCTAssert(host.realm != nil, "realm doesnt exist")
        XCTAssert(host.allCategories != categories, "coredata allcategories doesn't exist")
         */
       // host.setupText()
        /*
        XCTAssert(host.titleTextField.placeholder == "Session title", "Session title placeholder is wrong")
        XCTAssert(host.profTextField.placeholder == "Profession", "Session profession placeholder is wrong")
        XCTAssert(host.eduTextField.placeholder == "Education", "Session education placeholder is wrong")*/
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


