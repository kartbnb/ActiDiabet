//
//  PlanViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 24/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController {
    
    ///This is the viewcontroller of plan page
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    private var records: [Record] = []
    private var index = 0
    
    private var coredata: CoredataProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        coredata = delegate?.coredataController
        
        tableView.delegate = self
        tableView.dataSource = self
        // get device status bar height
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let notch = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 50 + notch, width: self.view.frame.width, height: 50), buttonTitle: ["Done", "To Do"])
        codeSegmented.backgroundColor = .clear
        codeSegmented.delegate = self
        
        view.addSubview(codeSegmented)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        index = 0
        if index == 0 {
            self.records = coredata!.fetchTodayRecords()
            tableView.reloadData()
        } else {
            self.records = coredata!.fetchFuturePlan()
            tableView.reloadData()
        }
    }
    
    //MARK: - Perform Records functions
    // fetch records today/future
    func getRecords() {
        if index == 0{
            self.records = coredata!.fetchTodayRecords()
        } else {
            self.records = coredata!.fetchFuturePlan()
        }
    }
    
    // calculate how many sections are needed when in future view
    func getSections(records: [Record]) -> Int {
        var sections = 0
        var dateStart = Date()
        for record in records {
            print(record.activity)
            let newDateStart = Calendar.current.startOfDay(for: record.date!)
            if dateStart != newDateStart {
                sections += 1
                dateStart = newDateStart
            }
        }
        return sections
    }
    
    // generate section titles (Date of each section)
    func getSectionTitles(records: [Record]) -> [Date] {
        var titles = [Date]()
        var dateStart = Date()
        for record in records {
            let newDateStart = Calendar.current.startOfDay(for: record.date!)
            if dateStart != newDateStart {
                titles.append(newDateStart)
                dateStart = newDateStart
            }
        }
        return titles
    }
    
    // get records for each section
    func getSectionRecords(records: [Record], on date: Date) -> [Record] {
        var recordinDate = [Record]()
        for record in records {
            let recordDate = record.date!
            let calendar = Calendar.current
            let dateStart = calendar.startOfDay(for: recordDate)
            if dateStart == date {
                recordinDate.append(record)
            }
        }
        return recordinDate
    }
    
    private func getRecord(section: Int, row: Int) -> Record {
        let titles = self.getSectionTitles(records: self.records)
        let title = titles[section]
        let recordsInSection = self.getSectionRecords(records: self.records, on: title)
        let record = recordsInSection[row]
        return record
    }
    
    private func getIndexOfRecord(record: Record) -> Int? {
        for i in 0..<records.count {
            if records[i] == record {
                return i
            }
        }
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Segment control delegate
extension PlanViewController: CustomSegmentedControlDelegate {
    func changeToIndex(index: Int) {
        self.index = index
        getRecords()
        tableView.reloadData()
    }
}

//MARK: - TableViewDelegate and TableViewDataSource
extension PlanViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if index == 0 {
            return 1
        } else {
            let sections = self.getSections(records: records)
            return sections
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if index == 0 {
            return records.count
        } else {
            let titles = self.getSectionTitles(records: records)
            let rows = self.getSectionRecords(records: records, on: titles[section]).count
            return rows
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if index == 0{
            return "Today's achievements"
        } else {
            let titles = self.getSectionTitles(records: records)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            return formatter.string(from: titles[section])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plan") as! PlanTableViewCell
        if index == 0 {
            cell.setRecord(record: records[indexPath.row])
        } else {
            let titles = self.getSectionTitles(records: records)
            let sectionRecord = self.getSectionRecords(records: records, on: titles[indexPath.section])
            cell.setRecord(record: sectionRecord[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.index == 1 {
                let record = self.getRecord(section: indexPath.section, row: indexPath.row)
                guard let recordIndex = self.getIndexOfRecord(record: record) else { return }
                coredata?.deletePlan(record: record)
                self.records.remove(at: recordIndex)
                tableView.reloadData()
            } else {
                let record = records[indexPath.row]
                coredata?.deletePlan(record: record)
                self.records.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
}
