//
//  EventViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 16/5/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

protocol EventDelegate {
    func setEvents(events: [Event])
}

class EventViewController: UIViewController, EventDelegate {
    
    /// This class is the view controller of Event
  
    @IBOutlet weak var tableView: UITableView!
    var events: [Event] = []
    let identifier = "event"
    
    var eventsAPI: EventsAPI?
    
    var isloading: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.eventsAPI = delegate.eventsAPI
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventsAPI?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventsAPI?.removeListener(listener: self)
    }
    
    func setEvents(events: [Event]) {
        self.events = events
        isloading = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
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

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == events.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "indicator") as! IndicatorTableViewCell
            cell.startAnimating()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! EventTableViewCell
            cell.setEvent(event: events[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // set event height 200
        if indexPath.row == events.count {
            return 50
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != events.count {
            if let cell = tableView.cellForRow(at: indexPath) as? EventTableViewCell {
                cell.openURL() // open url
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            print("has reached bottom search next \(self.events.count)")
            if self.isloading == false {
                print("not loading fetch next page")
                isloading = true
                eventsAPI?.performAPI(offset: self.events.count)
            } else {
                print("is already loading, stop fetch")
            }
            // Notify interested parties that end has been reached
            
        }
    }
    
    
}


