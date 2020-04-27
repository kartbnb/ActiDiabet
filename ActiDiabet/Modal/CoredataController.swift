//
//  CoredataController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 24/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit
import CoreData

class CoredataController: NSObject, NSFetchedResultsControllerDelegate, CoredataProtocol {

    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    // Results
    var recordFetchedResultController: NSFetchedResultsController<Record>?
    
    var records: [Record]
    
    override init() {
        records = [Record]()
        persistentContainer = NSPersistentContainer(name: "LogDataModal")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Coredata stack \(error)")
            }
        }
        super.init()
    }
    
    // Save context to core data
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    func fetchThisWeekRecord() -> [Record] {
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        let nameSortDescriptor = NSSortDescriptor(key: "word", ascending: true)
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        let predicate = NSPredicate(format: "wordBook == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        recordFetchedResultController = NSFetchedResultsController<Record>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        recordFetchedResultController?.delegate = self
        
        do {
            try recordFetchedResultController?.performFetch()
        } catch {
            print("Fetch Request failed: \(error)")
        }
        

        var records = [Record]()
        if recordFetchedResultController?.fetchedObjects != nil {
            records = (recordFetchedResultController?.fetchedObjects)!
        }

        return records
    }
    
    func addActivity(activity: Activity, duration: Int, date: Date) {
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Record", into: persistentContainer.viewContext) as! Record
        newRecord.activity = activity.activityName
        newRecord.duration = Int64(duration)
        newRecord.type = activity.activityType.toString()
        newRecord.done = false
        newRecord.date = date
        saveContext()
        print("save success \(activity.activityName), duration: \(duration)")
    }
    
    func finishActivity(activity: Activity, duration: Int) {
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Record", into: persistentContainer.viewContext) as! Record
        newRecord.activity = activity.activityName
        newRecord.duration = Int64(duration)
        newRecord.type = activity.activityType.toString()
        newRecord.done = true
        let currenDate = Date()
        newRecord.date = currenDate
        saveContext()
        print("save success \(activity.activityName), duration: \(duration)")
    }
    
    func fetchActivityThisWeek() -> [Record] {
        
        // get first day and last day of this week
        var calendar = Calendar.current
        calendar.timeZone = .current
        let today = Date()
        let dayOfToday = Calendar.current.component(.weekday, from: today) - 1
        let dateFromToday = calendar.startOfDay(for: Date())// eg. 2016-10-10 00:00:00
        let dateFrom = calendar.date(byAdding: .day, value: -dayOfToday, to: dateFromToday)!
        let dateTo = calendar.date(byAdding: .day, value: 7 - dayOfToday, to: dateFromToday)!
        
        
        
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        let predicate = NSPredicate(format: "date >= %@ and date <= %@", dateFrom as NSDate, dateTo as NSDate)
        let dontPredicate = NSPredicate(format: "done == %@", NSNumber(value: true))
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, dontPredicate])
        recordFetchedResultController = NSFetchedResultsController<Record>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        recordFetchedResultController?.delegate = self
        do {
            try recordFetchedResultController?.performFetch()
        } catch {
            print("Fetch request failed: \(error)")
        }
        var records = [Record]()
        if recordFetchedResultController?.fetchedObjects != nil {
            records = (recordFetchedResultController?.fetchedObjects)!
        }
        return records
    }
    
    func fetchTodayRecords() -> [Record] {
        let today = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        let dateFrom = calendar.startOfDay(for: today)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
        
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        let predicate = NSPredicate(format: "date >= %@ and date <= %@", dateFrom as NSDate, dateTo as NSDate)
        let dontPredicate = NSPredicate(format: "done == %@", NSNumber(value: true))
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, dontPredicate])
        recordFetchedResultController = NSFetchedResultsController<Record>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        recordFetchedResultController?.delegate = self
        do {
            try recordFetchedResultController?.performFetch()
        } catch {
            print("Fetch request failed: \(error)")
        }
        var records = [Record]()
        if recordFetchedResultController?.fetchedObjects != nil {
            records = (recordFetchedResultController?.fetchedObjects)!
        }
        return records
    }
    
    func fetchFuturePlan() -> [Record] {
        let today = Date()
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        let predicate = NSPredicate(format: "date >= %@", today as NSDate)
        let dontPredicate = NSPredicate(format: "done == %@", NSNumber(value: false))
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, dontPredicate])
        recordFetchedResultController = NSFetchedResultsController<Record>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        recordFetchedResultController?.delegate = self
        do {
            try recordFetchedResultController?.performFetch()
        } catch {
            print("Fetch request failed: \(error)")
        }
        var records = [Record]()
        if recordFetchedResultController?.fetchedObjects != nil {
            records = (recordFetchedResultController?.fetchedObjects)!
        }
        return records
        
    }
    

}

protocol CoredataProtocol {
    func finishActivity(activity: Activity, duration: Int)
    func fetchActivityThisWeek() -> [Record]
    func addActivity(activity: Activity, duration: Int, date: Date)
    func fetchTodayRecords() -> [Record]
    func fetchFuturePlan() -> [Record]
}
