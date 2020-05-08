//
//  ActivityCollectionViewCell.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 21/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {
    ///This is the custom view of activity in collection view of all activity view controller
    var activity: Activity?
    //outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    // set an actiivty into this view
    func setActivity(activity: Activity) {
        self.activity = activity
        self.nameLabel.text = activity.activityName
        self.imageView.image = activity.img
    }
    // get image from internet
}
