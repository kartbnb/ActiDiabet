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
        self.setImage(activity: activity)
        //imageView.image = UIImage(named: "indoor-light")
    }
    
    private func setImage(activity: Activity) {
        let str = link+"activity/img/\(activity.activityID!)"
        let url = URL(string: str)
        
        if let url = url {
            URLSession.shared.dataTask(with: url) { (data, res, err) in
                if let err = err {
                    print(err)
                }
                if let data = data {
                    if let icon = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = icon
                        }
                        
                    }
                }
            }.resume()
        }
        
            
        
    }
}
