//
//  SettingViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 16/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    ///This is the viewcontroller for setting page
    
    var notification: Notifications?
    
    let intensityTitles = ["3 hours/week", "4 hours/week", "5 hours/week"]
    
    @IBOutlet weak var scrollView: SettingScrollView!

    @IBOutlet weak var zipView: UIView!
    @IBOutlet weak var intensityView: UIView!
    
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var intensityTextField: UITextField!
    
    var intensity: IntensityLevel?
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = UIApplication.shared.delegate as? AppDelegate
        self.notification = delegate?.notification
        self.view.backgroundColor = UIColor.secondarySystemBackground
        setupUI()
        setInputView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: UI functions
    //setup UI view
    private func setupUI() {
        zipView.makeRound()
        intensityView.makeRound()
        saveButton.makeRound()
        setupSavedData()
        
    }
    
    //setup saved data
    private func setupSavedData() {
        let zip = UserDefaults.standard.value(forKey: "zipcode") as? String
        let resistance = UserDefaults.standard.integer(forKey: "Resistance")
        zipTextField.text = zip
        switch resistance {
        case 20:
            intensityTextField.text = intensityTitles[0]
            self.intensity = .beginner
        case 40:
            intensityTextField.text = intensityTitles[1]
            self.intensity = .moderate
        case 60:
            intensityTextField.text = intensityTitles[2]
            self.intensity = .vigorous
        default:
            intensityTextField.text = "Error"
            self.intensity = nil
        }
        scrollView.vcdelegate = self
    }
    
    private func setInputView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        intensityTextField.inputView = pickerView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    // MARK: Button function
    // save all settings
    @IBAction func saveSettings(_ sender: Any) {
        let zip = zipTextField.text
        if checkzipcode(zip: zip ?? "") {
            UserDefaults.standard.set(zip, forKey: "zipcode")
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let db = delegate.databaseController
            db.fetchOpenSpaces()
        } else {
            showAlert(message: "Please enter a valid postcode", title: "Postode Error")
            return
        }
        let intensityController = Intensity()
        guard let i = self.intensity else { return }
        intensityController.setIntensity(intensity: i)
        intensityController.setResistanceTime()
        intensityController.setAeroTime()
    }
    
    // validation of zipcode
    private func checkzipcode(zip: String) -> Bool {
        if zip.count == 4 && zip.first == "3" {
            //self.zipCode = zip
            return true
        } else {
            return false
        }
    }
    
    private func showAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}


// MARK: extensions for resign textfield
extension SettingViewController: ResignTextFieldDelegate {
    func resignAll() {
        zipTextField.resignFirstResponder()
        intensityTextField.resignFirstResponder()
    }
}

extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return intensityTitles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.intensityTextField.text = intensityTitles[row]
        switch row {
        case 0:
            intensity = .beginner
        case 1:
            intensity = .moderate
        case 2:
            intensity = .vigorous
        default:
            intensity = nil
        }
    }
    
    
    
    
}

protocol ResignTextFieldDelegate {
    func resignAll()
}

class SettingScrollView: UIScrollView {
    
    var vcdelegate: ResignTextFieldDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        vcdelegate?.resignAll()
    }
}


