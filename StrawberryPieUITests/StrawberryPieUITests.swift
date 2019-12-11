//
//  StrawberryPieUITests.swift
//  StrawberryPieUITests
//
//  Created by Ilias Doukas on 30/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import XCTest

class StrawberryPieUITests: XCTestCase {
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

    func testExample() {
        
        // app.launch()
        // let btn = app.segmentedControls.buttons["Button"]
        // XCTAssertTrue(btn.exists)
        // btn.tap() // <-- tällä voit esim. jatkaa apissa eteenpäin ja ketjuttaa näkymiä. Näkymän vaihdon jälkeen voi esim testata että siellä oleva nappi on käytettävissä tai teksti luettavissa.
        
        
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    // Tests General Education Category since it has no content. Will fail if contets is added to it
    func testCategoryWithNoContent(){
        let app = XCUIApplication()
        app.tabBars.buttons["Categories"].tap()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"General Education").element.tap()
        let test = app.staticTexts["NoContentLabel"].exists
        XCTAssertTrue(test, "There was content")
    }
    // Tests The ICT Category because it has content. Will fail if there is nothing there.
    func testCategoryWithContent(){
        let app = XCUIApplication()
        app.tabBars.buttons["Categories"].tap()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"ICT").element.tap()
        let test = app.staticTexts["NoContentLabel"].exists
        XCTAssertFalse(test, "There was no content")
    }

    // This tests login
    func testLogin(){
        let app = XCUIApplication()
        app.tabBars.buttons["Login / Register"].tap()
        app.textFields["Username"].tap()
        app.textFields.element.typeText("foxer153")
        app.secureTextFields["Password"].tap()
        app.secureTextFields.element.typeText("test123")
        app.buttons["Login"].tap()
    }
    // This test will randomly fail at times. Tests chat message sending
    func testChat(){
        let app = XCUIApplication()
        testLogin()
        app.tables.staticTexts["I will tell you my secrets on how I became even better than Doughnut hating Yngwie"].tap()
        app.buttons["Chat"].tap()
        app.textFields["Enter message"].tap()
        app.typeText("Test Message")
        app.buttons["Send"].tap()
    }
    // Test that tries to create a session
    func testHosting(){
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        testLogin()
        tabBarsQuery.buttons["Feed"].tap()
        app.buttons["Host A session"].tap()
        app.textFields["Profession"].tap()
        app.typeText("TeST")
        app.textFields["Education"].tap()
        app.typeText("TEST")
        app.textFields["Session title"].tap()
        app.typeText("TEst")
        app.buttons["Pick a Category"].tap()
        app.tables.staticTexts["Misc & Unknown"].tap()
        let window = app.children(matching: .window).element(boundBy: 0)
        let element = window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textView).element(boundBy: 0).tap()
        app.typeText("This is made by a test")
        element.children(matching: .textView).element(boundBy: 1).tap()
        app.typeText("This is made by a test")
        app.buttons["Create Session"].tap()
    }
}
