//
//  StrawberryPieTests.swift
//  StrawberryPieTests
//
//  Created by iosdev on 31/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// For testing QA and HostQA basic Realm functionality

import XCTest
@testable import StrawberryPie

class QAControllerTest: XCTestCase {
    let testQAController = QAController()
    let testRealm = RealmDB.sharedInstance.realm
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func areThereSources() {
    }
    
    func isTabSelected() {
        let tab = testQAController.selectedTab
        // Testataan että tabinimellä on pituutta yli 0 merkkiä
        XCTAssertTrue(tab.count > 0)
    }
    
    func defaultTab() {
        // Default tab must be topic
        let tab = testQAController.selectedTab
        XCTAssertEqual(tab, "topic")
    }
    
    func sessionStatus() {
        // Latest archived session has only one active status and connection to Realm is successful
        if let gotTestRealm = testRealm {
            // Realm connection opened succesfully
        let testSession = gotTestRealm.objects(QASession.self).filter("archived = true").last
            //Atleast one session is archives
         XCTAssertFalse(testSession?.live == true)
         XCTAssertFalse(testSession?.upcoming == true)
        }
    }
    
    func latestSessionHasHost() {
        // Latest session has a host
        if let gotTestRealm = testRealm {
            // Realm is OK
            let testSession = gotTestRealm.objects(QASession.self).last
            let gotHost = testSession?.host[0]
            // Trying for host
            XCTAssertTrue(gotHost?.userName.count ?? 0 > 0)
        }
    }
    
    func latestSessionPopulateSourcesSimulation() {
        // Latest session has a host
        if let gotTestRealm = testRealm {
            // Realm is OK
            let testSession = gotTestRealm.objects(QASession.self).last
            if let gotTestSession = testSession {
                // Populate variables with data and check for existing strings
                let title = gotTestSession.title
                let desc = gotTestSession.sessionDescription
                let cat = gotTestSession.sessionCategory
                let hostprof = gotTestSession.profession
                let hostedu = gotTestSession.education
                XCTAssertTrue(title.count > 0)
                XCTAssertTrue(desc.count > 0)
                XCTAssertTrue(cat.count > 0)
                XCTAssertTrue(hostprof.count > 0)
                XCTAssertTrue(hostedu.count > 0)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}


