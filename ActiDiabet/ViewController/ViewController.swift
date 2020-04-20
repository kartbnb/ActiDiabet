//
//  ViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 14/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CustomViewProtocol {
    
    @IBOutlet weak var activityScroll: UIScrollView!
    @IBOutlet weak var firstActivityView: ActivityView!
    
    @IBOutlet weak var thirdActivityView: ActivityView!
    @IBOutlet weak var enterDetailView: EnterDetailView!
    @IBOutlet weak var secondActivityView: ActivityView!
    
    @IBOutlet weak var weatherView: WeatherView!
    @IBOutlet weak var calendarButton: CalendarButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
        calendarButton.delegate = self
        setupScroll()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarButton.getDate()
        firstEnter()
    }
    
    func setupSearch() {
        let searchController = UISearchController()
        searchController.searchBar.searchTextField.layer.cornerRadius = 20
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        searchController.searchBar.placeholder = "Search Activity"
        self.navigationItem.searchController = searchController
    }
    
    func setupUI() {
        weatherView.getCurrentWeather()
        self.navigationController?.navigationBar.isHidden = false
        
        //UserDefaults.standard.removeObject(forKey: "zipcode")
    }
    
    func setupScroll() {
        
        firstActivityView.setActivity(activity: sampleActivity[0])
        secondActivityView.setActivity(activity: sampleActivity[1])
        thirdActivityView.setActivity(activity: sampleActivity[3])
        firstActivityView.homeVC = self
        secondActivityView.homeVC = self
        thirdActivityView.homeVC = self
    }
    
    func firstEnter() {
        //UserDefaults.standard.set("3162", forKey: "zipcode")
        if UserDefaults.standard.value(forKey: "zipcode") == nil {
            self.navigationController?.navigationBar.isHidden = true
            enterDetailView.homeVC = self
        } else {
            enterDetailView.isHidden = true
            setupUI()
        }
    }
    
    func goCalendar() {
        print("go calendar")
    }
    
    func showActivity(activity: Activity) {
        performSegue(withIdentifier: "activityDetail", sender: activity)
    }
    
    func showAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activityDetail" {
            let vc = segue.destination as! ActivityDetailViewController
            let activity = sender as? Activity
            vc.activity = activity
        }
    }
    
    
}

protocol CustomViewProtocol {
    func goCalendar()
    func setupUI()
    func showAlert(message: String, title: String)
    func showActivity(activity: Activity)
}

