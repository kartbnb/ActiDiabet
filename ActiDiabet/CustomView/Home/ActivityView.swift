//
//  ActivityView.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 15/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class ActivityView: UIView {
    /// This view is the custom UIview which for activity
    var activity: Activity?
    
    var homeVC: CustomViewProtocol?
    
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var timeDuration: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // set corner and background color
    private func setupView() {
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor.white
    }
    
    // set an activity into this view
    func setActivity(activity: Activity) {
        //self.activityName.textColor = UIColor.white
        self.activity = activity
        self.activityName.text = activity.activityName
        self.timeDuration.text = "\(activity.duration)"
        
        if activity.like {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .systemRed
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .black
        }
        // build time label
        
        switch activity.activityType {
        case .aerobic:
            self.backgroundColor = ColorConstant.aerobicColor
        case .resistance:
            self.backgroundColor = ColorConstant.resistanceColor
        }
        self.layoutIfNeeded()
    }
    
    // touch inside activity go to detail
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let activity = activity else { return }
        homeVC?.showActivity(activity: activity)
    }
    
    // like button function
    @IBAction func likeIt(_ sender: UIButton) {
        self.activity?.changeFavourite()
        self.setActivity(activity: self.activity!)
    }
    

}
