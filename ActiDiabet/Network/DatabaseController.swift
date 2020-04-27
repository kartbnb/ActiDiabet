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
    case favourite
    case map
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func getActivities(activities: [Activity])
    func addLocation(place: OpenSpaces)
}

protocol DatabaseProtocol: AnyObject {
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addUser(intensity: String, postcode: String)
    func addReview(userid: String, activity: Activity, rate: Int)
    func searchActivity(str: String)
    func fetchAllActivities()
    func getOneRecommend(viewCard: FavouriteCardDelegate)
}

let link = "http://ieserver-env.eba-kpxgxhpr.ap-southeast-2.elasticbeanstalk.com/" 

class DatabaseController: NSObject {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    
    var favouriteController = FavouriteController()
    
    var activities: [Activity]
    
    var recommendActivities: [Activity]
    
    override init() {
        self.activities = []
        self.recommendActivities = []
        super.init()
    }
    
    func getOneRecommend(viewCard: FavouriteCardDelegate) {
        let favouriteController = FavouriteController()
        let favourites = favouriteController.getFavourite()
        if favourites != nil {
            print(favourites![0])
            let url = URL(string: link + "activity/search/byID/\(favourites![0])")
            if let url = url {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print(error)
                    }
                    if let data = data {
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        guard json != nil else { return }
                        guard let dictionary = json as? [String: Any] else { return }
                        guard let jsonArray = dictionary["result"] as? [[String: Any]]else { return }
                        let item = jsonArray[0]
                        guard let activity = Activity(json: item) else {
                            print("activity init failed \(item)")
                            return
                        }
                        activity.like = self.favouriteController.findUserLike(activity: activity)
                        viewCard.setActivity(activity: activity)
                    }
                }.resume()
            }
        } else {
            viewCard.setActivity(activity: nil)
        }
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
    
    private func performData(_ data: Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        guard json != nil else { return }
        guard let dictionary = json as? [String: Any] else { return }
        guard let jsonArray = dictionary["result"] as? [[String: Any]]else { return }
        self.activities = []
        for item in jsonArray {
            guard let activity = Activity(json: item) else {
                print("activity init failed \(item)")
                return
            }
            activity.like = self.favouriteController.findUserLike(activity: activity)
            self.activities.append(activity)
        }
        listeners.invoke { (listener) in
            if listener.listenerType == .all {
                listener.getActivities(activities: self.activities)
            } else if listener.listenerType == .recommend {
                listener.getActivities(activities: self.activities)
            } else if listener.listenerType == .favourite {
                listener.getActivities(activities: self.activities)
            }
        }
    }
    
    
    
    private func performUserID(_ data: Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        guard json != nil else { return }
        guard let dictionary = json as? [String: Any] else { return }
        guard let userid = dictionary["result"] as? String else { return }
        print("create account success, userid: \(userid)")
        UserDefaults.standard.set(userid, forKey: "userid")
    }
    

}

extension DatabaseController: DatabaseProtocol {
    func fetchRecommentActivity() {
        let url = URL(string: link + "activity/recommendation/1")
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
    
    func searchActivity(str: String) {
        let url = URL(string: link + "activity/search/byString/\(str)")
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
    
    func fetchFavouriteActivity() {
        
    }
    
    func fetchOpenSpaces() {
        let zip = UserDefaults.standard.object(forKey: "zipcode") as! String
        let placeUrl = URL(string: link + "activity/place/\(zip)")
        if let url = placeUrl {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    guard json != nil else { return }
                    guard let dictionary = json as? [String: Any] else { return }
                    guard let jsonArray = dictionary["result"] as? [[String: Any]]else { return }
                    jsonArray.forEach { (item) in
                        guard let location = OpenSpaces(json: item, type: .space) else { return }
                        self.listeners.invoke { (listener) in
                            if listener.listenerType == .map {
                                listener.addLocation(place: location)
                                self.fetchPools()
                            }
                        }
                        
                    }
                }
            }.resume()
        }
        
        
    }
    
    func fetchPools() {
        let zip = UserDefaults.standard.object(forKey: "zipcode") as! String
        let poolUrl = URL(string: link + "activity/pool/\(zip)")
        if let url = poolUrl {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    guard json != nil else { return }
                    guard let dictionary = json as? [String: Any] else { return }
                    guard let jsonArray = dictionary["result"] as? [[String: Any]]else { return }
                    jsonArray.forEach { (item) in
                        guard let location = OpenSpaces(json: item, type: .pool) else { return }
                        self.listeners.invoke { (listener) in
                            if listener.listenerType == .map {
                                listener.addLocation(place: location)
                            }
                        }
                        
                    }
                }
            }.resume()
        }
    }
    

    
    func addUser(intensity: String, postcode: String) {
        // postcode_intensity
        let url = URL(string: link + "adduser/\(postcode)_\(intensity)")
        if let url = url {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                if let data = data {
                    self.performUserID(data)
                }
            }.resume()
        }
        
    }
    
    func addReview(userid: String, activity: Activity, rate: Int) {
        let url = URL(string: link + "\(userid)_\(activity.activityID!)_\(rate)")
        if let url = url {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                if let data = data {
                    print(data)
                }
            }.resume()
        }
    }
    
    // MARK: Database Protocol
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .all {
            self.fetchAllActivities()
        } else if listener.listenerType == .recommend {
            self.fetchRecommentActivity()
        } else if listener.listenerType == .favourite {
            self.fetchFavouriteActivity()
        } else if listener.listenerType == .map {
            self.fetchOpenSpaces()
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
}
