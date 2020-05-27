//
//  EventsAPI.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 14/5/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation

protocol EventsProtocol: AnyObject {
    func addListener(listener: EventDelegate)
    func removeListener(listener: EventDelegate)
    func performAPI(offset: Int)
}

struct Event {
    var eventName: String
    var eventDescription: String
    var url: String
    var image: String
    var date: String
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String else { return nil }
        guard let description = json["description"] as? String else { return nil }
        guard let url = json["url"] as? String else { return nil }
        guard let images = json["images"] as? [String: Any] else { return nil }
        guard let allImages = images["images"] as? [[String: Any]] else { return nil }
        guard let transforms = allImages[0]["transforms"] as? [String: Any] else { return nil }
        guard let detailedTranforms = transforms["transforms"] as? [[String: Any]] else { return nil }
        guard let imageUrl = detailedTranforms.last!["url"] as? String else { return nil }
        guard let date = json["datetime_summary"] as? String else { return nil }
        self.eventName = name
        self.eventDescription = description
        self.url = url
        self.image = imageUrl
        self.date = date
    }
}

class EventsAPI: NSObject, EventsProtocol {
    
    var listener: EventDelegate?
    
    private let username = "activeboomers"
    private let password = "n8sh8cmxqs4s"
    
    var allEvents: [Event] = []
    var apiData: Data?
    
    override init() {
        super.init()
        performAPI(offset: 0)
    }
    
    func performAPI(offset: Int) {
        if offset == self.allEvents.count {
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()

            // create the request
            let url = URL(string: "https://api.eventfinda.com.au/v2/events.json?rows=10&offset=\(offset)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST" // http method POST
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization") // change http header for authorise
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let json = json {
                        if let dictionary = json as? [String: Any] {
                            if let events = dictionary["events"] as? [[String: Any]] {
                                for event in events {
                                    guard let newEvent = Event(json: event) else { return }
                                    self.allEvents.append(newEvent)
                                }
                                self.listener?.setEvents(events: self.allEvents)
                            }
                        }
                    }
                }
            }.resume()
        }
    }
    
    func addListener(listener: EventDelegate) {
        self.listener = listener
        listener.setEvents(events: allEvents)
    }
    
    func removeListener(listener: EventDelegate) {
        self.listener = nil
    }
}



