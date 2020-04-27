//
//  ActivityDetailViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 18/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class ActivityDetailViewController: UIViewController {
    
    var activity: Activity?
    
    var coredataController: CoredataProtocol?
    private var notificationCenter: Notifications?
    
    // Views
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var indoorView: UIView!
    @IBOutlet weak var typeView: UIView!
    
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var backButtonView: UIView!
    
    // Labels
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var indoorLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = UIApplication.shared.delegate as? AppDelegate
        self.coredataController = delegate?.coredataController
        self.notificationCenter = delegate?.notification
        guard let ac = activity else { return }
        self.setupView(id: ac.video)
        setRound()
        setInputView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        playerView.stopVideo()
    }

    func setupView(id: String) {
        self.activityLabel.text = activity?.activityName
        timeTextField.text = "\(activity?.duration ?? 0)"
        typeLabel.text = activity?.activityType.toString()
        if let activity = self.activity {
            if activity.indoor {
                indoorLabel.text = "Indoor"
                locationButton.isHidden = true
            } else {
                indoorLabel.text = "Outdoor"
                locationButton.isHidden = false
            }
            
            
        }
        setlikeButton()
        
        playerView.load(withVideoId: id)
    }
    
    func setlikeButton() {
        if let activity = self.activity {
            if activity.like {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                likeButton.tintColor = .systemRed
            } else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                likeButton.tintColor = .black
            }
        }
    }
    
    func setInputView() {
        let timePicker = UIPickerView()
        timePicker.delegate = self
        timeTextField.inputView = timePicker
    }

    func setRound() {
        backButtonView.makeCircular()
        backButtonView.backgroundColor = UIColor.black
        self.modifyView(view: titleView)
        self.modifyView(view: timeView)
        self.modifyView(view: indoorView)
        self.modifyView(view: typeView)
    }
    
    
    @IBAction func backButtonFunction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeActivity(_ sender: Any) {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let database = delegate.databaseController as DatabaseProtocol
        let userid = UserDefaults.standard.object(forKey: "userid") as! String
        guard let duration = Int(timeTextField.text!) else { return }
        guard let activity = activity else { return }
        coredataController?.finishActivity(activity: activity, duration: duration)
        let alert = UIAlertController(title: "Did you like this activity?", message: "", preferredStyle: .alert)
        let likeAction = UIAlertAction(title: "Like", style: .default) { (alertaction) in
            database.addReview(userid: userid, activity: self.activity!, rate: 1)
            self.navigationController?.popViewController(animated: true)
        }
        let dontlikeAction = UIAlertAction(title: "Dislike", style: .default) { (alertaction) in
            database.addReview(userid: userid, activity: self.activity!, rate: -1)
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(likeAction)
        alert.addAction(dontlikeAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func addToPlan(_ sender: Any) {
        let alert = UIAlertController(title: "Please select a time to plan", message: "", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            self.alertTextField = textfield
            let datePicker = UIDatePicker()
            datePicker.locale = Locale(identifier: "en_GB")
            datePicker.datePickerMode = .dateAndTime
            datePicker.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
            textfield.inputView = datePicker
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let save = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let duration = Int(self.timeTextField.text!) else { return }
            guard let date = self.dateForSelection else { return }
            guard let activity = self.activity else { return }
            self.notificationCenter?.createNotification(with: date)
            self.coredataController?.addActivity(activity: activity, duration: duration, date: date)
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(save)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeLike(_ sender: Any) {
        self.activity?.changeFavourite()
        self.setlikeButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        timeTextField.resignFirstResponder()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func modifyView(view: UIView) {
        view.layer.cornerRadius = 20
    }
    
    private var alertTextField: UITextField?
    private var dateForSelection: Date?
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        dateForSelection = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        alertTextField?.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
}

extension ActivityDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeTextField.text = "\(row + 1)"
    }
}

class DetailScrollView: UIScrollView {
    @IBOutlet weak var timeTextField: UITextField!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        timeTextField.resignFirstResponder()
    }
}
