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
    
    private var searchStatus: TableStatus = .all // search status, identify searching or not searching
    private var favouriteStatus: ShowFavourite = .all // show favourite status
    
    private var activities: [Activity] = []
    private var all: [Activity] = []
    private var searchedActivityTemp: [Activity] = []
    private var favouriteButton: UIButton!
    
    var type: ActivityType!
    var indoor: Bool!
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
        switch indoor {
        case true:
            self.navigationItem.title = "Indoor"
        case false:
            self.navigationItem.title = "Outdoor"
        case .none:
            self.navigationItem.title = "Browse"
        case .some(_):
            self.navigationItem.title = "Browse"
        }
        favouriteButton = UIButton.init(type: .custom)
        favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        //add function for button
        favouriteButton.addTarget(self, action: #selector(showFavourites), for: .touchUpInside)
        //set frame
        favouriteButton.frame = CGRect(x: 0, y: 0, width: 53, height: 51)

        let barButton = UIBarButtonItem(customView: favouriteButton)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
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
        searchBar.placeholder = "Search"
        searchBar.delegate = self
    }
    // Navigation segue prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToActivity" {
            let activity = sender as? Activity
            let destination = segue.destination as? ActivityDetailViewController
            destination?.activity = activity
        }
    }
    
    private func searchActivity(str: String) -> [Activity] {
        var searchActivities = [Activity]()
        for activity in all {
            if activity.activityName.contains(str) {
                searchActivities.append(activity)
            }
        }
        return searchActivities
    }
    
    private func getFavouriteActivity(activities: [Activity]) -> [Activity] {
        if self.favouriteStatus == .all {
            return activities
        } else {
            var favourites = [Activity]()
            for activity in activities {
                if activity.like {
                    favourites.append(activity)
                }
            }
            return favourites
        }
    }
    
    //MARK: Button function
    @objc func showFavourites(_ sender: UIButton) {
        switch self.favouriteStatus {
        case .all:
            self.favouriteStatus = .favourite
            self.favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            tableView.reloadData()
        case .favourite:
            self.favouriteStatus = .all
            self.favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            tableView.reloadData()
        }
    }
    
    
    
    //MARK: Database Listener
    var listenerType: ListenerType = .all
    
    private func getTypeActivities(allActivities: [Activity]) -> [Activity] {
        var typeActivity: [Activity] = []
        for activity in allActivities {
            if activity.activityType == type {
                typeActivity.append(activity)
            }
        }
        return typeActivity
    }
    
    private func getIndoorActivities(allActivities: [Activity]) -> [Activity] {
        var indoorActivity: [Activity] = []
        for activity in allActivities {
            if activity.indoor == self.indoor {
                indoorActivity.append(activity)
            }
        }
        return indoorActivity
    }
    
    func getActivities(activities: [Activity]) {
        self.activities = self.getIndoorActivities(allActivities: self.getTypeActivities(allActivities: activities))
        self.all = self.getIndoorActivities(allActivities: self.getTypeActivities(allActivities: activities))
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func addLocation(place: [OpenSpaces]) {
        
    }
}

// MARK: - TableView Delegate
extension AllActivityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getFavouriteActivity(activities: activities).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActivityTableViewCell
        cell.setActivity(activity: self.getFavouriteActivity(activities: activities)[indexPath.row])
        //cell.backgroundColor = .black
        // Configure the cell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.type.toString()) Activities"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 27)
        header.textLabel?.text = "\(self.type.toString()) Activities"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listToActivity", sender: self.getFavouriteActivity(activities: activities)[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
}

// MARK: -Search Bar Delegate
extension AllActivityViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchStatus = .all
        self.activities = self.all
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchStatus = .search
        if searchText.count == 0 {
            self.activities = self.all
        } else {
            self.activities = self.searchActivity(str: searchText)
        }
        tableView.reloadData()
    }
}

enum TableStatus {
    case all
    case search
}

enum ShowFavourite {
    case all
    case favourite
}

