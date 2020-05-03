//
//  Favourite.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 25/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation
import UIKit

class FavouriteController {
    ///This class is used for controlling user favourites
    private var standard = UserDefaults.standard
    
    func setFavourite(activity: Activity) {
        let favourites = standard.object(forKey: "favourites") as? [Int]
        var sets = Set<Int>()
        if favourites == nil {
            print("currents favourites \(sets)")
            sets.insert(activity.activityID!)
        } else {
            sets = Set(favourites!)
            print("currents favourites \(sets)")
            if sets.contains(activity.activityID!) {
                sets.remove(activity.activityID!)
            } else {
                sets.insert(activity.activityID!)
            }
        }
        print("new favourites \(sets)")
        standard.set(Array(sets), forKey: "favourites")
        
    }
    
    func getFavourite() -> [Int]? {
        let favourites = standard.array(forKey: "favourites") as? [Int]
        return favourites
    }
    
    
    
    func findUserLike(activity: Activity) -> Bool {
        guard let favourites = standard.array(forKey: "favourites") as? [Int] else { return false }
        for id in favourites {
            if activity.activityID == id {
                return true
            }
        }
        return false
    }
}
