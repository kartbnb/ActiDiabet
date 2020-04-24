//
//  Intensity.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 18/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation

let intensityLevelString = ["beginner", "moderate", "vigorous"]

enum IntensityLevel {
    case beginner
    case moderate
    case vigorous
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
