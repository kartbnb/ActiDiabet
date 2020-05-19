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

    ///This class is used for controlling coredata within the application
    
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
    
    // MARK: - Fetching Data
   
    // add a plan activity in to coredata
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
    
     // add a completed activity into coredata
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
    
    //fetch all activities done in this week
    func fetchActivityThisWeek() -> [Record] {
        
        // get first day and last day of this week
        var calendar = Calendar.current
        calendar.timeZone = .current
        let today = Date()
        let dayOfToday = Calendar.current.component(.weekday, from: today) - 1
        let dateFromToday = calendar.startOfDay(for: Date())// eg. 2016-10-10 00:00:00
        let dateFrom = calendar.date(byAdding: .day, value: -dayOfToday, to: dateFromToday)!
        let dateTo = calendar.date(byAdding: .day, value: 7 - dayOfToday, to: dateFromToday)!
        
        
        // perform fetch
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
    
    // fetch activities done for today
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
    
    // fetch plans in future
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
    
    // delete a record
    func deletePlan(record: Record) {
        persistentContainer.viewContext.delete(record)
        if record.done == false {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let notification = delegate.notification
            notification.removeNotification(with: record.date!)
        }
        self.saveContext()
    }
    

}

// protocol for coredata
protocol CoredataProtocol {
    func finishActivity(activity: Activity, duration: Int)
    func fetchActivityThisWeek() -> [Record]
    func addActivity(activity: Activity, duration: Int, date: Date)
    func fetchTodayRecords() -> [Record]
    func fetchFuturePlan() -> [Record]
    func deletePlan(record: Record)
    
}
