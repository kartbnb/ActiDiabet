//
//  SettingButtonView.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 14/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation
import UIKit

class CalendarButtonView: UIView {
    /// This is the custom view of calandar in main view controller
    //Outlets
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var delegate: CustomViewProtocol?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = 20.0
        //set click action
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_sender:)))
        self.addGestureRecognizer(gesture)
    }
    
    // get today information
    func getDate() {
        let today = Date()
        let formatting = DateFormatter()
        let weekday = formatting.shortWeekdaySymbols[Calendar.current.component(.weekday, from: today) - 1]
        formatting.dateFormat = "dd"
        self.dateLabel.text = formatting.string(from: today)
        self.dayLabel.text = weekday
    }
    
    // function when tapped
    @objc func tapped(_sender: UITapGestureRecognizer) {
        print("tapped")
        delegate?.goCalendar()
    }
}


