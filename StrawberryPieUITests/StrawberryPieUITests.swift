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
    func testCategoryWithNoContent(){
        
        let app = XCUIApplication()
        app.tabBars.buttons["Categories"].tap()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"General Education").element.tap()
        let test = app.staticTexts["NoContentLabel"].exists
        XCTAssertTrue(test, "There was content")
    }
}
