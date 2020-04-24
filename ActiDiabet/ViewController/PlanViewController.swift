//
//  PlanViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 24/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 50), buttonTitle: ["Done", "To Do"])
        codeSegmented.backgroundColor = .clear
        view.addSubview(codeSegmented)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
