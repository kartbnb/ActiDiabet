//
//  ActivityCollectionViewCell.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 21/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {
    
    var activity: Activity?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setActivity(activity: Activity) {
        self.activity = activity
        self.nameLabel.text = activity.activityName
        imageView.image = UIImage(named: "indoor-light")
    }
}
