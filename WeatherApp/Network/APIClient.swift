//
//  APIClient.swift
//  WeatherApp
//
//  Created by Nikhil Sakhare on 18/11/17.
//  Copyright © 2017 Nikhil Sakhare. All rights reserved.
//

import UIKit

class APIClient: NSObject {
    
    var updateCallBack: ((Entities, [Any]?) -> Void)?
    var fetchIntervalInMinutes: Int = 0
    var scheduledFetch: Bool = false
    var schedular : Timer?
    
    override init () {
        super.init()
        self.updateCallBack = nil
        self.schedular = nil
    }
    
    convenience init(callBack updateCallBack: @escaping (Entities, [Any]?) -> Void) {
        self.init()
        self.updateCallBack = updateCallBack
        if (AppDelegate.syncIntervalInMinutes > 0) {
            self.schedular = Timer.scheduledTimer(timeInterval: Double(AppDelegate.syncIntervalInMinutes) * 60.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateData() {
        
        fetchData {[unowned self] (requestType, response) in
            self.updateCallBack!(requestType, response)
        }
        
    }
    
    func fetchData(completion: @escaping (Entities, [Any]?) -> Void) {
        
        for entity in AppDelegate.syncEntities {
            APIClient.fetchList(requestType: entity, completion: completion)
        }
        
    }
    
    func stopFetch() {
        
        self.schedular?.invalidate()
        
    }
}


extension APIClient {
    
    class func fetchList(requestType: Entities, completion: @escaping (Entities ,[Any]?) -> Void) {
        
        guard let url = URL(string: URLBuilder().getURL(entity: requestType)) else {
            print("Error unwrapping URL"); return }
        let getRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let session: URLSession = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 10.0
            configuration.timeoutIntervalForResource = 10.0
            return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        }()
        let dataTask = session.dataTask(with: getRequest) { (data, response, error) in
            guard let unwrappedData = data else {
                print("Error getting data");
                completion(requestType, nil)
                return
            }
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? NSDictionary {
                    
                    if let data = responseJSON.value(forKeyPath: "list") as? [NSDictionary] {
                        completion(requestType, data)
                    } else {
                        completion(requestType, nil)
                        print("Error getting API data")
                    }
                }
            } catch {
                completion(requestType, nil)
            }
        }
        dataTask.resume()
        
    }
    
}
