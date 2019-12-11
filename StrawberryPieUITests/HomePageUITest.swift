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
    
    func chooseSessionAnd() {
        let app = XCUIApplication()
        app.tables.staticTexts["This is a short description of my Q and A Sessionnnnnnnnnnnnnnnnn"].tap()
        XCTAssert(true, "Test passed")
    }
    
    func testSearchbar() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results
        let app = XCUIApplication()
        app.searchFields["Search Sessions"].tap()
        app.searchFields.element.typeText("How I became")
        let test = app.staticTexts["How I became a guitar legend"].exists
        XCTAssertTrue(test, "test was found")
    }
}
