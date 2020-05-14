//
//  ActivityFilterViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 13/5/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class ActivityFilterViewController: UIViewController, TypeChooseDelegate {

    @IBOutlet weak var aerobicView: TypeFilterView!
    @IBOutlet weak var resistanceView: TypeFilterView!
    
    var indoor: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aerobicView.type = .aerobic
        aerobicView.delegate = self
        aerobicView.makeRound()
        resistanceView.type = .resistance
        resistanceView.delegate = self
        resistanceView.makeRound()
        // Do any additional setup after loading the view.
    }
    
    func typeChoose(type: ActivityType?) {
        guard let type = type else { return }
        performSegue(withIdentifier: "showAllActivity", sender: type)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllActivity" {
            let type = sender as? ActivityType
            let destination = segue.destination as! AllActivityViewController
            destination.type = type
            destination.indoor = self.indoor
        }
    }
    

}

class TypeFilterView: UIView {
    
    var type: ActivityType?
    var delegate: TypeChooseDelegate?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.typeChoose(type: self.type)
    }
    
}

protocol TypeChooseDelegate {
    func typeChoose(type: ActivityType?)
}
