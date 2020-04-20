//
//  WeatherView.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 14/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation
import UIKit

class WeatherView: UIView {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = ColorConstant.mainColor
        self.layer.cornerRadius = 20.0
    }
    
    func getCurrentWeather() {
        cityLabel.textColor = UIColor.white
        tempLabel.textColor = UIColor.white
        cityLabel.text = "Loading"
        tempLabel.text = ""
        let weatherapi = WeatherAPI()
        weatherapi.getCurrentWeather(weatherView: self)
    }
    
    func setupWeather(weather: Weather?) {
        self.cityLabel.textColor = UIColor.white
        self.tempLabel.textColor = UIColor.white
        guard let weather = weather else {
            self.cityLabel.text = "no weather data"
            return
        }
        self.cityLabel.text = weather.city
        self.tempLabel.text = "\(weather.temp)°C"
        let url = URL(string: "https://openweathermap.org/img/wn/\(weather.image)@2x.png")
        if let url = url {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let icon = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.weatherImage.image = icon
                        }
                    }
                }
            }.resume()
        }
    }
}
