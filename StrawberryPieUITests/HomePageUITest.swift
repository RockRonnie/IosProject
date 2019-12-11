//
//  HomePageUITest.swift
//  StrawberryPieUITests
//
//  Created by iosdev on 10/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import XCTest

class HomePageUITest: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        print("hack") // älä poista, tää romu vaatii tän printin jotta joku höbölöbö library käynnistyy
        app = XCUIApplication()
        app.launch()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func chooseSession() {
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["This is a short description of my Q and A Sessionnnnnnnnnnnnnnnnn"]/*[[".cells.staticTexts[\"This is a short description of my Q and A Sessionnnnnnnnnnnnnnnnn\"]",".staticTexts[\"This is a short description of my Q and A Sessionnnnnnnnnnnnnnnnn\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Chat"]/*[[".segmentedControls.buttons[\"Chat\"]",".buttons[\"Chat\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Nostot"]/*[[".segmentedControls.buttons[\"Nostot\"]",".buttons[\"Nostot\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Aihe"]/*[[".segmentedControls.buttons[\"Aihe\"]",".buttons[\"Aihe\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
   
        
    }

}
