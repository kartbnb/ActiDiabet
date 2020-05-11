//
//  AllActivityViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 21/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class AllActivityViewController: UIViewController, DatabaseListener {
    /// This is the view controller of all activity page
    
    var searchStatus: TableStatus = .all // search status, identify searching or not searching
    
    var activities: [Activity] = []
    
    // collection view variables
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow:CGFloat = 2
    private let reuseIdentifier = "activities"
    
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // database protocol
    weak var databaseProtocol: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = UIApplication.shared.delegate as?  AppDelegate
        self.databaseProtocol = delegate?.databaseController
        
        tableView.delegate = self
        tableView.dataSource = self
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.searchTextField.text = ""
        databaseProtocol?.addListener(listener: self)
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseProtocol?.removeListener(listener: self)
    }
    //MARK: Setup UI function
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
    }
    // setup search delegate and ui
    func setupSearch() {
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.placeholder = "Search Activity"
        searchBar.delegate = self
    }
    // 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToActivity" {
            let activity = sender as? Activity
            let destination = segue.destination as? ActivityDetailViewController
            destination?.activity = activity
        }
    }
    
    //MARK: Database Listener
    var listenerType: ListenerType = .all
    
    func getActivities(activities: [Activity]) {
        self.activities = activities
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func addLocation(place: [OpenSpaces]) {
        
    }
}

extension AllActivityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("activities number \(activities.count)")
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActivityTableViewCell
        print("now showing \(indexPath.row)")
        cell.setActivity(activity: activities[indexPath.row])
        //cell.backgroundColor = .black
        // Configure the cell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listToActivity", sender: activities[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
}

extension AllActivityViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchStatus = .all
        databaseProtocol?.fetchAllActivities()
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchStatus = .search
        if searchText.count == 0 {
            databaseProtocol?.fetchAllActivities()
        } else {
            databaseProtocol?.searchActivity(str: searchText)
        }
        tableView.reloadData()
    }
}

enum TableStatus {
    case all
    case search
}

