//
//  PlanTableViewCell.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 25/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class PlanTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentViewCard: UIView!
    
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    var record: Record?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRecord(record: Record) {
        if record.done {
            doneButton.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
        } else {
            doneButton.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
        }
        self.record = record
        activityName.text = record.activity
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: record.date!)
        durationLabel.text = "\(record.duration)"
    }

}
