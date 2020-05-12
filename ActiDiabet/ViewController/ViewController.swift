//
//  ViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 14/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

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
    var coredataController: CoredataProtocol?
    var databaseController: DatabaseProtocol?
    
    // progress view
    @IBOutlet weak var resistanceProgress: UIProgressView!
    @IBOutlet weak var aerobicProgress: UIProgressView!
    
    //labels related to benchmark
    @IBOutlet weak var aerobicLabel: UILabel!
    @IBOutlet weak var resistanceLabel: UILabel!
    
    var recommendActivities = [sampleActivity[0], sampleActivity[1]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarButton.delegate = self
        let delegate = UIApplication.shared.delegate as? AppDelegate
        coredataController = delegate?.coredataController
        databaseController = delegate!.databaseController
        
        // progress bar transformation
        //aerobicProgress.transform = aerobicProgress.transform.scaledBy(x: 1, y: 16)
        aerobicProgress.layer.cornerRadius = 10
        aerobicProgress.clipsToBounds = true
        //resistanceProgress.transform = resistanceProgress.transform.scaledBy(x: 1, y: 16)
        resistanceProgress.layer.cornerRadius = 10
        resistanceProgress.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //recommendActivities = [sampleActivity[0], sampleActivity[1]]
        super.viewWillAppear(animated)
        firstEnter()
        //databaseController?.getOneRecommend(viewCard: favouriteCard)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: Check if First enter the application
    func firstEnter() {
        if UserDefaults.standard.value(forKey: "zipcode") == nil {
            // first enter show enterdetail view
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            enterDetailView.homeVC = self
        } else {
            // not first enter show main page
            enterDetailView.isHidden = true
            setupUI()
        }
    }
    // MARK: UI functions
    // setup UIs
    func setupUI() {
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
        
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        //UserDefaults.standard.removeObject(forKey: "zipcode")
    }
    
    //setup ScrollView
    func setupScroll() {
        if self.recommendActivities.count >= 2 {
            DispatchQueue.main.async {
                self.firstActivityView.setActivity(activity: self.recommendActivities[0])
                self.secondActivityView.setActivity(activity: self.recommendActivities[1])
            }
            firstActivityView.homeVC = self
            secondActivityView.homeVC = self
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
    
    //MARK: progress calculator
    func getProgressOfWeek(records: [Record]) -> [Float] {
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
//        if weatherString == "01d" || weatherString == "02d" || weatherString == "03d" || weatherString == "04d" {
//            self.recommendActivities = activities
//        } else {
//            self.recommendActivities = indoorActivity
//        }
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
}


