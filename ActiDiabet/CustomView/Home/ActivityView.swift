//
//  ActivityView.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 15/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class ActivityView: UIView {
    
    var activity: Activity?
    
    var homeVC: CustomViewProtocol?
    
    @IBOutlet weak var activityName: UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    private func setupView() {
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor.white
    }
    
    func setActivity(activity: Activity) {
        self.activityName.textColor = UIColor.white
        self.activity = activity
        self.activityName.text = activity.activityName
        
        // build time label
        let width = self.bounds.width * 0.5
        let timeDuration = UILabel(frame: CGRect(x: 20.0, y: 50.0, width: width, height: 80))
        timeDuration.textColor = UIColor.white
        timeDuration.font = UIFont.boldSystemFont(ofSize:90.0)
        timeDuration.textAlignment = .center
        timeDuration.text = "\(activity.duration)"
        timeDuration.adjustsFontSizeToFitWidth = true
        timeDuration.minimumScaleFactor = 0.5
        self.addSubview(timeDuration)
        
        //build mins label
        let minsLabel = UILabel(frame: .zero)
        self.addSubview(minsLabel)
        minsLabel.text = "mins"
        minsLabel.textColor = UIColor.white
        minsLabel.textAlignment = .left
        minsLabel.translatesAutoresizingMaskIntoConstraints = false
        let leadConstraint = NSLayoutConstraint(item: minsLabel, attribute: .leading, relatedBy: .equal, toItem: timeDuration, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let trailConstraint = NSLayoutConstraint(item: minsLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let btmConstraint = NSLayoutConstraint(item: minsLabel, attribute: .bottom, relatedBy: .equal, toItem: timeDuration, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([leadConstraint, trailConstraint, btmConstraint])
        

        switch activity.activityType {
        case .aerobic:
            self.backgroundColor = ColorConstant.aerobicColor
        case .resistance:
            self.backgroundColor = ColorConstant.resistanceColor
        }
        self.layoutIfNeeded()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let activity = activity else { return }
        homeVC?.showActivity(activity: activity)
    }

}
