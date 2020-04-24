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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = UIApplication.shared.delegate as? AppDelegate
        self.coredataController = delegate?.coredataController
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
        playerView.load(withVideoId: id)
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
        guard let duration = Int(timeTextField.text!) else { return }
        guard let activity = activity else { return }
        coredataController?.finishActivity(activity: activity, duration: duration)
        showAlert(message: "", title: "Do you like this activity?")
        
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
    
    func showAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let likeAction = UIAlertAction(title: "like", style: .default) { (alertaction) in
            self.navigationController?.popViewController(animated: true)
        }
        let dontlikeAction = UIAlertAction(title: "dislike", style: .default) { (alertaction) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(likeAction)
        alert.addAction(dontlikeAction)
        self.present(alert, animated: true, completion: nil)
        
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
