//
//  Activity.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 15/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation

let exercisePreferences = ["Aerobic", "Resistance"]

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
    let activityName: String
    let activityType: ActivityType
    let indoor: Bool
    let duration: Int
    let video: String
    
    init(name: String, type: String, indoor: Bool, duration: Int, video: String) {
        self.activityName = name
        self.indoor = indoor
        if type == "Aerobic exercise" {
            activityType = .aerobic
        } else {
            activityType = .resistance
        }
        self.duration = duration
        self.video = video
    }
}

let sampleActivity = [
                        Activity(name: "aerobic exercise classes", type: "Aerobic exercise", indoor: true, duration: 7, video: "Zwi5IzpQJBs"),
                        Activity(name: "cycling", type: "Aerobic exercise", indoor: false, duration: 30, video: "hznfKSDSdhE"),
                        Activity(name: "swimming", type: "Aerobic exercise", indoor: false, duration: 30, video: "uEOvqKpf_lc"),
                        Activity(name: "Yoga", type: "Resistance exercise", indoor: true, duration: 7, video: "NDLad2vOHkU")
                    ]



