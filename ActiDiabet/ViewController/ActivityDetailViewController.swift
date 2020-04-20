//
//  ActivityDetailViewController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 18/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class ActivityDetailViewController: UIViewController {
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var indoorView: UIView!
    @IBOutlet weak var indoorImage: UIImageView!
    @IBOutlet weak var indoorLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var backButtonView: UIView!
    
    var activity: Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        guard let ac = activity else { return }
        self.setupView(id: ac.video)
        setRound()
        // Do any additional setup after loading the view.
    }
    
    func setupView(id: String) {
        self.activityLabel.text = activity?.activityName
        playerView.load(withVideoId: id)
        timeLabel.text = "\(activity?.duration ?? 0)"
        guard let activity = self.activity else { return }
        if activity.indoor {
            indoorLabel.text = "indoor"
            indoorImage.image = UIImage(named: "indoor-light")
        } else {
            indoorLabel.text = "outdoor"
            indoorImage.image = UIImage(named: "outdoor-light")
        }
    }
    
    func setRound() {
        backButtonView.makeCircular()
        backButtonView.backgroundColor = UIColor.white
        timeView.layer.cornerRadius = 10
        timeView.backgroundColor = ColorConstant.resistanceColor
        indoorView.layer.cornerRadius = 10
        indoorView.backgroundColor = ColorConstant.resistanceColor
        doneButton.backgroundColor = ColorConstant.secondMainColor
        doneButton.layer.cornerRadius = 10
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

extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
}
