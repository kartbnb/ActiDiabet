//
//  EnterDetailView.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 14/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class WelcomeView: UIView {
    
    @IBOutlet weak var startButton: StartButtonView!
    
}

class StartButtonView: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.cornerRadius = 20
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.4
    }
}

class EnterZipView: UIView {
    
    @IBOutlet weak var zipTextField: UITextField!
    
    fileprivate var zipCode: String?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        zipTextField.resignFirstResponder()
    }
    
    func getZipCodeSave() -> Bool {
        let zip = zipTextField.text
        if let zip = zip {
            return self.checkzipcode(zip: zip)
        } else {
            return false
        }
    }
    
    func checkzipcode(zip: String) -> Bool {
        if zip.count == 4 && zip.first == "3" {
            self.zipCode = zip
            return true
        } else {
            return false
        }
    }
    
}

class EnterIntensityView: UIView {
    
    @IBOutlet weak var intensityTextField: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        intensityTextField.resignFirstResponder()
    }
    
    fileprivate func setInputView() {
        self.finishButton.isEnabled = false
        let pickerView = UIPickerView()
        pickerView.delegate = self
        intensityTextField.inputView = pickerView
    }
    
    func getIntensity() -> IntensityLevel? {
        if let i = intensityTextField.text {
            if i == intensityLevelString[0] {
                return .beginner
            } else if i == intensityLevelString[1] {
                return .moderate
            } else if i == intensityLevelString[2] {
                return .vigorous
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}

extension EnterIntensityView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return intensityLevelString[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        intensityTextField.text = intensityLevelString[row]
        finishButton.isEnabled = true
    }
}

class EnterDetailView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var homeVC: CustomViewProtocol?
    
    @IBOutlet weak var welcomeView: WelcomeView!
    @IBOutlet weak var enterZipView: EnterZipView!
    @IBOutlet weak var chooseIntensityView: EnterIntensityView!
    

    @IBAction func startUsing(_ sender: Any) {
        print("start button clicked")
        enterZipView.alpha = 0
        enterZipView.isHidden = false
        chooseIntensityView.alpha = 0
        chooseIntensityView.isHidden = true

        
        // dismiss welcome view
        UIView.animate(withDuration: 1.0, animations: {
            self.welcomeView.alpha = 0
        }) { (finished) in
            self.welcomeView.isHidden = finished
            // show enter zip view
            UIView.animate(withDuration: 1.0) {
                self.enterZipView.alpha = 1
            }
        }
        
    }
    
    @IBAction func saveZip(_ sender: Any) {
        print("next button clicked")
        chooseIntensityView.isHidden = false
        if enterZipView.getZipCodeSave() {
            UserDefaults.standard.set(enterZipView.zipCode, forKey: "zipcode")
            print("save zip successful")
            UIView.animate(withDuration: 1.0, animations: {
                // dismiss enter zip view
                self.enterZipView.alpha = 0
            }) { (finished) in
                self.enterZipView.isHidden = finished
                UIView.animate(withDuration: 1.0, animations: {
                    self.chooseIntensityView.alpha = 1
                    self.chooseIntensityView.setInputView()
                }) 
            }
        } else {
            homeVC!.showAlert(message: "Please enter a valid zip code", title: "Zip Code Error")
        }
        
    }
    
    @IBAction func saveIntensity(_ sender: Any) {
        guard let intensity = chooseIntensityView.getIntensity() else { return }
        let intensityObject = Intensity()
        intensityObject.setIntensity(intensity: intensity)
        UIView.animate(withDuration: 1.0, animations: {
            self.alpha = 0
        }) { (finished) in
            self.isHidden = finished
            self.homeVC?.setupUI()
        }
    }
    
}
