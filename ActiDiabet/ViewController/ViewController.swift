//
//  ViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 14/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CustomViewProtocol {
    
    @IBOutlet weak var firstActivityView: ActivityView!
    
    @IBOutlet weak var enterDetailView: EnterDetailView!
    @IBOutlet weak var secondActivityView: ActivityView!
    
    @IBOutlet weak var weatherView: WeatherView!
    @IBOutlet weak var calendarButton: CalendarButtonView!
    
    var coredataController: CoredataProtocol?
    
    @IBOutlet weak var resistanceProgress: UIProgressView!
    @IBOutlet weak var aerobicProgress: UIProgressView!
    
    @IBOutlet weak var aerobicLabel: UILabel!
    @IBOutlet weak var resistanceLabel: UILabel!
    
    @IBOutlet weak var favouriteView: UIView!
    @IBOutlet weak var achieveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarButton.delegate = self
        setupScroll()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        coredataController = delegate?.coredataController
        aerobicProgress.transform = aerobicProgress.transform.scaledBy(x: 1, y: 8)
        resistanceProgress.transform = resistanceProgress.transform.scaledBy(x: 1, y: 8)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        firstEnter()
    }
    
    func setupUI() {
        favouriteView.makeRound()
        achieveView.makeRound()
        
        weatherView.getCurrentWeather()
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        //UserDefaults.standard.removeObject(forKey: "zipcode")
    }
    
    func setupScroll() {
        
        firstActivityView.setActivity(activity: sampleActivity[0])
        secondActivityView.setActivity(activity: sampleActivity[3])
        firstActivityView.homeVC = self
        secondActivityView.homeVC = self
    }
    
    func firstEnter() {
        //UserDefaults.standard.set("3162", forKey: "zipcode")
        if UserDefaults.standard.value(forKey: "zipcode") == nil {
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
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
    
    
}

protocol CustomViewProtocol {
    func goCalendar()
    func setupUI()
    func showAlert(message: String, title: String)
    func showActivity(activity: Activity)
}


