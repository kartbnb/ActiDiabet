//
//  Intensity.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 18/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation

let intensityLevelString = ["Beginner", "Moderate", "Vigorous"]
let intensityDescrString = ["Requires some effort and you should feel an increase in your breathing but you can still hold a conversation (e.g. brisk walking, cycling).", "If you currently do no physical activity, start by doing some activity and then gradually build up. You could start by joining together short blocks of exercise, such as combining a 15 minute walk with 15 minutes of cycling to make 30 minutes of moderate exercise.", "Involves activities that make you breathe harder, puff and pant (e.g. jogging, circuit classes)."]

enum IntensityLevel {
    case beginner
    case moderate
    case vigorous
    
    func toString() -> String {
        switch self {
        case .beginner:
            return intensityLevelString[0]
        case .moderate:
            return intensityLevelString[1]
        case .vigorous:
            return intensityLevelString[2]
        }
    }
}

class Intensity {
    var intensity: IntensityLevel?
    
    func setIntensity(intensity: IntensityLevel) {
        self.intensity = intensity
        setAeroTime()
        setResistanceTime()
        
    }
    
    func setAeroTime() {
        switch self.intensity {
        case .beginner:
            UserDefaults.standard.set(120, forKey: "Aerobic")
        case .moderate:
            UserDefaults.standard.set(180, forKey: "Aerobic")
        case .vigorous:
            UserDefaults.standard.set(210, forKey: "Aerobic")
        case .none:
            print("no intensity error")
        }
    }
    
    func setResistanceTime() {
        switch self.intensity {
        case .beginner:
            UserDefaults.standard.set(20, forKey: "Resistance")
        case .moderate:
            UserDefaults.standard.set(40, forKey: "Resistance")
        case .vigorous:
            UserDefaults.standard.set(60, forKey: "Resistance")
        case .none:
            print("no intensity error")
        }
    }
        
    
}
