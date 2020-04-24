//
//  DatabaseController.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 22/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import Foundation

enum ListenerType {
    case all
    case recommend
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func getAllActivities(activities: [Activity])
    func getRecommendActivity(activities: [Activity])
}

protocol DatabaseProtocol: AnyObject {
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}

fileprivate let link = "http://127.0.0.1:5000/"

class DatabaseController: NSObject {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    
    
    var activities: [Activity]
    
    override init() {
        self.activities = []
        super.init()
        self.fetchAllActivities()
    }
    
    func fetchAllActivities() {
        let url = URL(string: link + "activity")
        if let url = url {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                if let data = data {
                    self.performData(data)
                }
            }.resume()
        }
    }
    
    func performData(_ data: Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        guard json != nil else { return }
        guard let dictionary = json as? [String: Any] else { return }
        guard let jsonArray = dictionary["result"] as? [[String: Any]]else { return }
        
        for item in jsonArray {
            guard let activity = Activity(json: item) else {
                print("activity init failed \(item)")
                return
            }
            self.activities.append(activity)
        }
        listeners.invoke { (listener) in
            switch listener.listenerType {
            case .all:
                listener.getAllActivities(activities: activities)
            case .recommend:
                listener.getRecommendActivity(activities: [])
            }
        }
        
    }
    

}

extension DatabaseController: DatabaseProtocol {
    // MARK: Database Protocol
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        switch listener.listenerType {
        case .all:
            listener.getAllActivities(activities: activities)
        case .recommend:
            listener.getRecommendActivity(activities: activities)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
}
