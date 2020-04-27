//
//  AllActivityViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 21/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class AllActivityViewController: UIViewController, DatabaseListener {
    
    var searchStatus: TableStatus = .all
    
    var activities: [Activity] = []
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow:CGFloat = 2
    private let reuseIdentifier = "activities"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var databaseProtocol: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = UIApplication.shared.delegate as?  AppDelegate
        self.databaseProtocol = delegate?.databaseController
        
        collectionView.delegate = self
        collectionView.dataSource = self
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.searchTextField.text = ""
        databaseProtocol?.addListener(listener: self)
        setupUI()
        //databaseProtocol?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseProtocol?.removeListener(listener: self)
    }
    func setupSearch() {
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.placeholder = "Search Activity"
        searchBar.delegate = self
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
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
            self.collectionView.reloadData()
        }
    }
    func addLocation(place: OpenSpaces) {
        
    }
}

extension AllActivityViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return activities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ActivityCollectionViewCell
        cell.setActivity(activity: activities[indexPath.row])
        //cell.backgroundColor = .black
        // Configure the cell
        cell.contentView.frame = cell.bounds
        cell.contentView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth ,.flexibleHeight]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listToActivity", sender: activities[indexPath.row])
    }
}

extension AllActivityViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem / 7 * 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension AllActivityViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchStatus = .all
        databaseProtocol?.fetchAllActivities()
        collectionView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchStatus = .search
        if searchText.count == 0 {
            databaseProtocol?.fetchAllActivities()
        } else {
            databaseProtocol?.searchActivity(str: searchText)
        }
        collectionView.reloadData()
    }
}

enum TableStatus {
    case all
    case search
}

