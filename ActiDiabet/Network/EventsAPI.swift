//
//  EventsAPI.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 14/5/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation

class EventsAPI {
    private let username = "activeboomers"
    private let password = "n8sh8cmxqs4s"
    
    var apiData: Data?
    
    func performAPI() {
        if let url = URL(string: "https://api.eventfinda.com.au/v/events.json?rows=2"){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                print(data)
                print(response)
                print(error)
            }.resume()
        }
    }
    
    func performAPIRequest() {
        var apiRequest: URLRequest? = nil
        if let url = URL(string: "http://api.eventfinda.com.au/v/events.json?rows=2") {
            apiRequest = URLRequest(url: url)
        }
        var connection: NSURLConnection? = nil
        if let apiRequest = apiRequest {
            connection = NSURLConnection(request: apiRequest, delegate: self)
        }
        connection?.start()
    }
    
    func connection(_ connection: NSURLConnection, didReceive challenge: URLAuthenticationChallenge) {
        let newCredential = URLCredential(
            user: "USERNAME",
            password: "PASSWORD",
            persistence: .forSession)
        challenge.sender?.use(newCredential, for: challenge)
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        apiData = Data()
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        apiData!.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        var apiResponse: [AnyHashable : Any]? = nil
        do {
            apiResponse = try JSONSerialization.jsonObject(with: apiData!, options: []) as? [AnyHashable : Any]
        } catch {
        }
        let events = apiResponse?["events"] as? [AnyHashable]

        for event in events ?? [] {
            guard let event = event as? [AnyHashable : Any] else {
                continue
            }
            if let object = event["name"] {
                print("\(object)")
            }
            let images = event["images"] as? [AnyHashable : Any]
            let image_collection = images?["images"] as? [AnyHashable]
            for image in image_collection ?? [] {
                guard let image = image as? [AnyHashable : Any] else {
                    continue
                }
                if let object = image["id"] {
                    print("\(object)")
                }
                let transforms = image["transforms"] as? [AnyHashable : Any]
                let transform_collection = transforms?["transforms"] as? [AnyHashable]
                for transform in transform_collection ?? [] {
                    guard let transform = transform as? [AnyHashable : Any] else {
                        continue
                    }
                    if let object = transform["url"] {
                        print("\(object)")
                    }
                }
            }
        }
    }
}
