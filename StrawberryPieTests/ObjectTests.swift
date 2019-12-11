//
//  ObjectTests.swift
//  StrawberryPieTests
//
//  Created by iosdev on 10/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation
import XCTest
@testable import StrawberryPie

class ObjectTests: XCTestCase {
    
    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    func chatMessageTest(){
        let testMessage = ChatMessage()
        XCTAssert(testMessage.body == "", "body is derp")
        let user = User()
        let body = "test2"
        testMessage.body = "test"
        XCTAssert(testMessage.body == "test", "Testmessage is not correct")
        testMessage.body = body
        XCTAssert(testMessage.body == body, "Testmessage2 is not correct")
        testMessage.messageUser.append(user)
        XCTAssert(testMessage.messageUser.count == 1, "testmessage user object count is not correct")
        XCTAssert(testMessage.messageUser[0].userID == user.userID, "testmessage user doesnt match the user object")
    }
    func qaTest(){
        let testQA = QA()
        let testQA2 = QA()
        let testQuestion = ChatMessage()
        let testAnswer = ChatMessage()
        let normalUser = User()
        let expert = User()
        let question = "Do i exist?"
        let answer = "Yes you do!"
        testQuestion.body = question
        testQuestion.messageUser.append(normalUser)
        testAnswer.body = answer
        testAnswer.messageUser.append(expert)
        XCTAssert(testQuestion.body == question, "Question is wrong")
        XCTAssert(testAnswer.body == answer, "Question is wrong")
        XCTAssert(testQuestion.messageUser[0] == normalUser, "normaluser is wrong")
        XCTAssert(testAnswer.messageUser[0] == expert, "normaluser is wrong")
        testQA.question.append(testQuestion)
        testQA.answer.append(testAnswer)
        XCTAssert(testQA.question[0] == testQuestion, "TestQuestion differs from original")
        XCTAssert(testQA.answer[0] == testAnswer, "TestQuestion differs from original")
        //Twisting it a bit
        testQA2.answer.append(testQuestion)
        testQA2.question.append(testAnswer)
        XCTAssert(testQA != testQA2, "testQA and testQA2 are the same")
        XCTAssert(testQA2.answer != testQA.answer, "Answers are the same?")
        XCTAssert(testQA2.question != testQA.question, "questions are the same?")
        XCTAssert(testQA2.answer == testQA.question, "qa2 answer is not qa1 question")
    }
    func chatTest(){
        let testChat = Chat()
        let testMessage = ChatMessage()
    }
    
    func sessionTest(){
        
    }
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
