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
            UserDefaults.standard.set(15, forKey: "Aerobic")
        case .moderate:
            UserDefaults.standard.set(30, forKey: "Aerobic")
        case .vigorous:
            UserDefaults.standard.set(45, forKey: "Aerobic")
        case .none:
            print("no intensity error")
        }
    }
    
    func setResistanceTime() {
        switch self.intensity {
        case .beginner:
            UserDefaults.standard.set(5, forKey: "Resistance")
        case .moderate:
            UserDefaults.standard.set(10, forKey: "Resistance")
        case .vigorous:
            UserDefaults.standard.set(15, forKey: "Resistance")
        case .none:
            print("no intensity error")
        }
    }
        
    
}
