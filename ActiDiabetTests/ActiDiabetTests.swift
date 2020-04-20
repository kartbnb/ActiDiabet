//
//  ActiDiabetTests.swift
//  ActiDiabetTests
//
//  Created by 佟诗博 on 14/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import XCTest
@testable import ActiDiabet

class ActiDiabetTests: XCTestCase {

    override func setUpWithError() throws {
        UserDefaults.standard.set("3163", forKey: "zipcode")
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: "zipcode")
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }


}
