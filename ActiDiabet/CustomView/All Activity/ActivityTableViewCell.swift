//
//  ActivityCollectionViewCell.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 21/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    ///This is the custom view of activity in collection view of all activity view controller
    var activity: Activity?
    //outlets
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    // set an actiivty into this view
    func setActivity(activity: Activity) {
        self.activity = activity
        self.nameLabel.text = activity.activityName
        self.iconImage.image = activity.img
        if activity.like {
            self.favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.favouriteButton.tintColor = .systemPink
        } else {
            self.favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            self.favouriteButton.tintColor = .systemGray
        }
    }
    
    @IBAction func changeFavourite(_ sender: Any) {
        self.activity?.changeFavourite()
        self.setActivity(activity: self.activity!)
    }
    
}
