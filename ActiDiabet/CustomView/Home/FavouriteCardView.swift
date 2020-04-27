//
//  FavouriteCardView.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 26/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class FavouriteCardView: UIView, FavouriteCardDelegate {

    var activity: Activity?
    var homeVC: CustomViewProtocol?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setActivity(activity: Activity?) {
        self.activity = activity
        if activity == nil {
            nameLabel.text = ""
        } else {
            DispatchQueue.main.async {
                self.nameLabel.text = activity!.activityName
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.activity != nil {
            homeVC?.showActivity(activity: self.activity!)
        }
    }
        
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

protocol FavouriteCardDelegate {
    func setActivity(activity: Activity?)
}
