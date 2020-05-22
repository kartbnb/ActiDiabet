//
//  Activity.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 15/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation
import UIKit

let exercisePreferences = ["Aerobic", "Resistance"]

let indoorActivity = [Activity(json: ["id":12, "activity_name": "Chair Exercise ", "type": "Resistance exercise", "duration": 3, "indoor": "True", "video_url": "rYywHxYe4U8"])!, Activity(json: ["id": 17, "activity_name": "Char Squat", "type": "Resistance exercise", "duration": 3, "indoor": "True", "video_url": "DDALnEtV1GA"])!]

enum ActivityType {
    case aerobic
    case resistance
    
    func toString() -> String{
        switch self {
        case .aerobic:
            return exercisePreferences[0]
        case .resistance:
            return exercisePreferences[1]
        }
    }
    
    func toType(string: String) -> ActivityType {
        if string == exercisePreferences[0] {
            return .aerobic
        } else {
            return .resistance
        }
    }
}

class Activity {
    
    ///This class is used for modeling activity which get from database
    
    let activityID: Int?
    let activityName: String
    let activityType: ActivityType
    let indoor: Bool
    let duration: Int
    let video: String
    var like: Bool
    var img: UIImage?
    let short: String
    
//    init(id: Int, name: String, type: String, indoor: Bool, duration: Int, video: String) {
//        self.activityName = name
//        self.indoor = indoor
//        if type == "Aerobic exercise" {
//            activityType = .aerobic
//        } else {
//            activityType = .resistance
//        }
//        self.duration = duration
//        self.video = video
//        self.activityID = id
//        self.like = false
//    }
    
    // Generate by json
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int else {
            print("key id not found")
            return nil
        }
        guard let name = json["activity_name"] as? String else {
            print("key name not found")
            return nil
        }
        guard let type = json["type"] as? String else {
            print("key type not found")
            return nil }
        guard let indoor = json["indoor"] as? String else {
            print("key indoor not found")
            return nil }
        guard let duration = json["duration"] as? Int else {
            print("key duration not found")
            return nil }
        guard let video = json["video_url"] as? String else {
            print("key video not found")
            return nil }
        guard let img = json["img"] as? String else {
            print("key img not found")
            return nil }
        guard let shortName = json["short_name"] as? String else {
            print("short_name key not found")
            return nil
        }
        self.activityID = id
        self.activityName = name
        if type == "Aerobic exercise" {
            self.activityType = .aerobic
        } else {
            self.activityType = .resistance
        }
        
        if indoor == "True" {
            self.indoor = true
        } else {
            self.indoor = false
        }
        self.duration = duration
        self.video = video
        self.like = false
        self.short = shortName
        let str = link+"activity/img/\(Int(img) ?? 1)"
        let url = URL(string: str)
        
        if let url = url {
            URLSession.shared.dataTask(with: url) { (data, res, err) in
                if let err = err {
                    print(err)
                }
                if let data = data {
                    if let icon = UIImage(data: data) {
                        self.img = icon
                    }
                }
            }.resume()
        }
    }

    
    // change favourite
    func changeFavourite() {
        self.like = !self.like
        let favourites = FavouriteController()
        favourites.setFavourite(activity: self)
    }
}




