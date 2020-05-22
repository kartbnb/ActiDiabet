//
//  ViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 14/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController, CustomViewProtocol, DatabaseListener {
    
    ///Main ViewController
    
    // Views
    @IBOutlet weak var firstActivityView: ActivityView!
    @IBOutlet weak var secondActivityView: ActivityView!
    @IBOutlet weak var achieveView: UIView!
    @IBOutlet weak var enterDetailView: EnterDetailView!
   
    
    @IBOutlet weak var weatherView: WeatherView!
    @IBOutlet weak var calendarButton: CalendarButtonView!
    
    // coredata controller and database controller
    private var coredataController: CoredataProtocol?
    private var databaseController: DatabaseProtocol?
    
    // progress view
    @IBOutlet weak var resistanceProgress: UIProgressView!
    @IBOutlet weak var aerobicProgress: UIProgressView!
    
    //labels related to benchmark
    @IBOutlet weak var aerobicLabel: UILabel!
    @IBOutlet weak var resistanceLabel: UILabel!
    
    var recommendActivities = [Activity]()
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarButton.delegate = self
        let delegate = UIApplication.shared.delegate as? AppDelegate
        coredataController = delegate?.coredataController
        databaseController = delegate!.databaseController
        aerobicProgress.layer.cornerRadius = 10
        aerobicProgress.clipsToBounds = true
        resistanceProgress.layer.cornerRadius = 10
        resistanceProgress.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstEnter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: Check if First enter the application
    private func firstEnter() {
        if UserDefaults.standard.value(forKey: "userid") == nil {
            // first enter show enterdetail view
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            enterDetailView.homeVC = self
        } else {
            // not first enter show main page
            enterDetailView.isHidden = true
            setIndicator()
            setupUI()
        }
    }
    // MARK: UI functions
    // setup UIs
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        weatherView.getCurrentWeather()
        databaseController?.addListener(listener: self)
        guard let records = coredataController?.fetchActivityThisWeek() else { return }
        let benchMark = self.getProgressOfWeek(records: records)
        aerobicLabel.text = "\(Int(benchMark[0] * 100))%"
        resistanceLabel.text = "\(Int(benchMark[1] * 100))%"
        if benchMark[0] > 1{
            aerobicProgress.setProgress(1, animated: true)
        } else {
            aerobicProgress.setProgress(benchMark[0], animated: true)
        }
        if benchMark[1] > 1 {
            resistanceProgress.setProgress(1, animated: true)
        } else {
            resistanceProgress.setProgress(benchMark[1], animated: true)
        }
        calendarButton.getDate()
        if let userid = UserDefaults.standard.object(forKey: "userid") as? String {
            
            print("already get userid \(userid)")
        } else {
            print("no userid")
        }
        achieveView.makeRound()
        
    }
    
    func setIndicator() {
        indicator = UIActivityIndicatorView(frame: self.view.frame)
        indicator.backgroundColor = .white
        indicator.style = .large
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    //setup ScrollView
    private func setupScroll() {
        if self.recommendActivities.count >= 2 {
            DispatchQueue.main.async {
                self.firstActivityView.setActivity(activity: self.randomActivity(type: .resistance))
                self.secondActivityView.setActivity(activity: self.randomActivity(type: .aerobic))
            }
            firstActivityView.homeVC = self
            secondActivityView.homeVC = self
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
        } else {
            
        }
    }
    
    //Click calendar button
    func goCalendar() {
        print("go calendar")
    }
    
    //show activity detail when click any activity
    func showActivity(activity: Activity) {
        performSegue(withIdentifier: "activityDetail", sender: activity)
    }
    
    //MARK: show alert function
    func showAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - progress calculator
    private func getProgressOfWeek(records: [Record]) -> [Float] {
        var aerobicTime = 0
        var resistanceTime = 0
        for record in records {
            if record.type == "Aerobic" {
                aerobicTime += Int(record.duration)
            } else {
                resistanceTime += Int(record.duration)
            }
        }
        
        let aerobicGoal = UserDefaults.standard.integer(forKey: "Aerobic")
        let resistanceGoal = UserDefaults.standard.integer(forKey: "Resistance")
        if aerobicGoal == 0 {
            return [0.0, 0.0]
        } else {
            let aerobicPercent: Float = Float(aerobicTime) / Float(aerobicGoal)
            let resistancePercent: Float = Float(resistanceTime) / Float(resistanceGoal)
            return [aerobicPercent, resistancePercent]
        }
    }
    
    private func randomActivity(type: ActivityType) -> Activity {
        var activities:[Activity] = []
        for activity in recommendActivities {
            if activity.activityType == type {
                activities.append(activity)
            }
        }
        let random = GKRandomSource.sharedRandom().nextInt(upperBound: activities.count)
        return activities[random]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activityDetail" {
            let vc = segue.destination as! ActivityDetailViewController
            let activity = sender as? Activity
            vc.activity = activity
        }
    }
    
    // MARK: - Database Listener
    var listenerType: ListenerType = .recommend
    
    func getActivities(activities: [Activity]) {
        self.recommendActivities = activities
        self.setupScroll()
    }
    
    func addLocation(place: [OpenSpaces]) {
        
    }
    
}


protocol CustomViewProtocol {
    func goCalendar()
    func setupUI()
    func showAlert(message: String, title: String)
    func showActivity(activity: Activity)
    func setIndicator()
}


