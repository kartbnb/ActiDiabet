//
//  EventTableViewCell.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 16/5/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowLayerView: UIView!
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var url: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setEvent(event: Event) {
        self.setBackground()
        self.titleLabel.text = event.eventName
        self.descLabel.text = event.eventDescription
        self.url = event.url
        self.picture.contentMode = .scaleAspectFill
        self.setImage(url: event.image)
    }
    
    // set UI of cell
    private func setBackground() {
        self.backGroundView.layer.cornerRadius = 20
        self.shadowLayerView.layer.cornerRadius = 20
        self.shadowLayerView.layer.shadowColor = UIColor.black.cgColor
        self.shadowLayerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowLayerView.layer.shadowRadius = 10
        self.shadowLayerView.layer.shadowOpacity = 0.1
        self.backGroundView.clipsToBounds = true
        self.picture.clipsToBounds = true
    }
    
    private func setImage(url: String) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let netWorkImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.picture?.image = netWorkImage
                        }
                    }
                }
            }.resume()
        }
    }
    
    func openURL() {
        // open the url of event
        if let url = URL(string: self.url!) {
            UIApplication.shared.open(url)
        }
    }

}
