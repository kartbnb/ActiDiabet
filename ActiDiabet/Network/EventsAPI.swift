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
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        var dataTask: URLSessionDataTask?
        if let url = URL(string: "https://api.eventfinda.com.au/v/events.json?rows=2"){
            session.dataTask(with: url) { (data, response, error) in
                print(data)
                print(response)
                print(error)
            }.resume()
        }
    }
    
    private func createCredential() -> URLCredential {
        let credential = URLCredential(user: username, password: password, persistence: URLCredential.Persistence.forSession)
        return credential
    }
}

extension EventsAPI: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("did receive challenge")
        let newCredential = URLCredential(
            user: username,
            password: password,
            persistence: .forSession)
        print("using credential")
        completionHandler(.useCredential, newCredential)
    }
}
