//
//  ZipCodeTests.swift
//  ActiDiabetTests
//
//  Created by 佟诗博 on 14/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import XCTest
@testable import ActiDiabet

class ZipCodeTests: XCTestCase {
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testZipCodeEnter() {
        let zipView = EnterZipView()
        let correct = zipView.checkzipcode(zip: "3162")
        XCTAssertTrue(correct)
        let more = zipView.checkzipcode(zip: "31634")
        XCTAssertFalse(more)
        let less = zipView.checkzipcode(zip: "314")
        XCTAssertFalse(less)
        let otherState = zipView.checkzipcode(zip: "6000")
        XCTAssertFalse(otherState)
    }
    
    
}
