//
//  IndoorFilterViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 14/5/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class IndoorFilterViewController: UIViewController, IndoorChooseDelegate {
    
    private let identifier = "indoor"
    
    @IBOutlet weak var outdoorView: IndoorFilterView!
    @IBOutlet weak var indoorView: IndoorFilterView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outdoorView.delegate = self
        outdoorView.indoor = false
        indoorView.delegate = self
        indoorView.indoor = true
        // Do any additional setup after loading the view.
    }

    //MARK: Indoor choose delegate
    func indoorChoose(indoor: Bool) {
        performSegue(withIdentifier: "chooseType", sender: indoor)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "chooseType" {
            let destination = segue.destination as! ActivityFilterViewController
            let indoor = sender as! Bool
            destination.indoor = indoor
        }
    }
    

    
    
}

class IndoorFilterView: UIView {
    
    var indoor: Bool?
    var delegate: IndoorChooseDelegate?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.indoorChoose(indoor: self.indoor!)
    }
    
}

protocol IndoorChooseDelegate {
    func indoorChoose(indoor: Bool)
}


