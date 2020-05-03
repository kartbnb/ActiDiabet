//
//  UIViewExtension.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 24/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

extension UIView {
    // make uiview to circle
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
    
    // make uiview have round corner
    func makeRound() {
        self.layer.cornerRadius = 20
    }
}
