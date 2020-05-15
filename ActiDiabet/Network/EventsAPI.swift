//
//  EventsAPI.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 14/5/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation

class EventsAPI: NSObject {
    private let username = "activeboomers"
    private let password = "n8sh8cmxqs4s"
    
    var apiData: Data?
    
    func performAPI() {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        // create the request
        let url = URL(string: "https://api.eventfinda.com.au/v2/events.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let json = json {
                    print(json)
                }
            }
        }.resume()
        
    }
}

