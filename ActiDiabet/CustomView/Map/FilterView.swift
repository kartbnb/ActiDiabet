//
//  FilterView.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 11/5/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class FilterView: UIView {
    ///This class is for filter in map view
    
    private var locationFilter: LocationType!
    private var imgView: UIImageView!
    private var titleView: UILabel!
    
    private var textColor: UIColor = .black
    
    var filterDelegate: FilterDelegate?
    
    private var inFilter: Bool = false
    
    // init function
    convenience init(frame: CGRect, type: LocationType, inFilter: Bool) {
        self.init(frame: frame)
        self.locationFilter = type
        self.inFilter = inFilter
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    private func updateView() {
        setView()
        createImg()
        setTitle()
    }

    // set title of each filter
    private func setTitle() {
        titleView = UILabel(frame: CGRect(x: 50, y: 10, width: self.frame.width - 50, height: 30))
        switch locationFilter {
        case .bbq:
            titleView.text = "BBQ"
        case .cycling:
            titleView.text = "Rail"
        case .hoop:
            titleView.text = "Hoop"
        case .hospital:
            titleView.text = "Hospital"
        case .picnic:
            titleView.text = "Picnic"
        case .pool:
            titleView.text = "Pool"
        case .seat:
            titleView.text = "Seat"
        case .space:
            titleView.text = "Park"
        case .water:
            titleView.text = "Water"
        default:
            titleView.text = "Toilet"
        }
        addSubview(titleView)
    }

    //set basic view of this custom view
    private func setView() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        setFilter()
        self.layer.masksToBounds = true
    }
    
    // if it is in filter, show border blue, if is not, border white
    private func setFilter() {
        if self.inFilter {
            self.layer.borderColor = UIColor.blue.cgColor
        } else {
            self.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    // set the image of each filter
    private func createImg() {
        imgView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imgView.contentMode = .scaleToFill
        switch locationFilter {
        case .bbq:
            imgView.image = UIImage(named: "map-bbq")
        case .cycling:
            imgView.image = UIImage(named: "map-bike_rail")
        case .hoop:
            imgView.image = UIImage(named: "map-hoop")
        case .hospital:
            imgView.image = UIImage(named: "map-hospital")
        case .picnic:
            imgView.image = UIImage(named: "map-picnic")
        case .pool:
            imgView.image = UIImage(named: "map-swimming")
        case .seat:
            imgView.image = UIImage(named: "map-seat")
        case .space:
            imgView.image = UIImage(named: "map-park")
        case .water:
            imgView.image = UIImage(named: "map-water")
        default:
            imgView.image = UIImage(named: "map-toilet")
        }
        addSubview(imgView)
    }
    
    // touch in function, change border color when touch inside
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inFilter = !self.inFilter
        filterDelegate?.changeFilter(type: self.locationFilter)
        setFilter()
    }
    
}

// filter delegate, when changing filter, update map
protocol FilterDelegate: class {
    func changeFilter(type: LocationType)
}
