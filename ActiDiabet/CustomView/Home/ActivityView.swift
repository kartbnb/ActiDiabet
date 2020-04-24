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
    @IBOutlet weak var timeDuration: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    

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
        //self.activityName.textColor = UIColor.white
        self.activity = activity
        self.activityName.text = activity.activityName
        self.timeDuration.text = "\(activity.duration)"
        // build time label
        
        

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
