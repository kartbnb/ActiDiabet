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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_sender:)))
        self.addGestureRecognizer(gesture)
    }
    
    func getDate() {
        let today = Date()
        let formatting = DateFormatter()
//        print(formatting.shortWeekdaySymbols)
//        print(Calendar.current.component(.weekday, from: today))
        let weekday = formatting.shortWeekdaySymbols[Calendar.current.component(.weekday, from: today) - 1]
        formatting.dateFormat = "dd"
        //print(formatting.string(from: today))
        self.dateLabel.text = formatting.string(from: today)
        self.dayLabel.text = weekday
    }
    
    
    
    
    
    @objc func tapped(_sender: UITapGestureRecognizer) {
        print("tapped")
        delegate?.goCalendar()
    }
}


