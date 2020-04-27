//
//  RecordTests.swift
//  ActiDiabetTests
//
//  Created by 佟诗博 on 25/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import XCTest
@testable import ActiDiabet
import CoreData

class RecordTests: XCTestCase {

    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testRecord() {
        let vc = PlanViewController()
        var records = [Record]()
        let noRecord = vc.getSections(records: records)
        XCTAssertEqual(0, noRecord)
        for i in 0...3 {
            let record = NSEntityDescription.insertNewObject(forEntityName: "Record", into: NSPersistentContainer(name: "LogDataModal").viewContext) as! Record
            let today = Date()
            let calendar = Calendar.current
            let dayFin = calendar.date(byAdding: .day, value: i, to: today)
            record.date = dayFin!
            records.append(record)
        }
        let fourRecords = vc.getSections(records: records)
        XCTAssertEqual(4, fourRecords)
        records = []
        for i in 0...2 {
            let record = NSEntityDescription.insertNewObject(forEntityName: "Record", into: NSPersistentContainer(name: "LogDataModal").viewContext) as! Record
            let today = Date()
            let calendar = Calendar.current
            let dayFin = calendar.date(byAdding: .minute, value: i, to: today)
            record.date = dayFin!
            records.append(record)
        }
        let oneDay = vc.getSections(records: records)
        XCTAssertEqual(1, oneDay)
        
        
    }
}
