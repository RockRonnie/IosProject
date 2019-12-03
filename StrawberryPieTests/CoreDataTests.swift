//
//  CoreDataTests.swift
//  StrawberryPieTests
//
//  Created by iosdev on 03/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import StrawberryPie

class CoreDataTests: XCTestCase {
    let category = Category()
    let work = Work()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    //Testing Category CoreData
    func testDelete(){
        category.deleteAllData(entity: "Category")
        XCTAssert(category.getNames().count == 0, "Failed to delete")
    }
    func testFetch(){
        print(category.getNames().count)
        category.generateData()
        XCTAssert(category.getNames().count == 12, "Something went wrong. There should be 12 categories")
    }
    func testCreateCategory(){
        category.createCategoryData(name: "Test", summary: "Test", imageName: "ICTImage", id: 1)
        let result = category.getEntity(name: "Test")
        XCTAssert(result.count == 1, "Failed to create")
    }
    //Testing Work CoreData
    func testCreateWork(){ //Also tests the fetch
        work.createWorkPosition(name: "Engineer")
        let result = work.getWorkPositionWithName(name: "Engineer")
        XCTAssert(result.count == 1, "Failed to create Position")
    }
    
    func testUpdate(){
        //work.deleteWorkWithName(name: "Police")
        //work.deleteWorkWithName(name: "Police")
        //work.deleteWorkWithName(name: "Police")
        //work.deleteWorkWithName(name: "Police")
        //work.deleteWorkWithName(name: "Police")
        //work.deleteWorkWithName(name: "Police")
        //work.deleteWorkWithName(name: "Police")
        //work.deleteWorkWithName(name: "Police")
        //work.deleteWorkWithName(name: "Police")
        //work.deleteWorkWithName(name: "Police")
        //work.deleteWorkWithName(name: "Police")
        //work.deleteWorkWithName(name: "Police")
        work.createWorkPosition(name: "Engineer")
        work.updateWorkWithName(oldName: "Engineer", newName: "Police", summary: nil)
        let result = work.getWorkPositionWithName(name: "Police")
        print(result.count)
        XCTAssert(result.count == 1, "Failed to update")
    }
    func fetchFail(){
        work.createWorkPosition(name: "Engineer")
        let result = work.getWorkPositionWithName(name: "Test")
        XCTAssert(result.count == 0 , "Something went wrong")
    }
    
    func testDeleteWork(){
        work.createWorkPosition(name: "Engineer")
        work.deleteWorkWithName(name: "Engineer")
        let result = work.getWorkPositionWithName(name: "Engineer")
        XCTAssert(result.count == 0, "Failed to remove position")
    }
  
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

