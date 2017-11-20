//
//  DataProvider.swift
//  WeatherApp
//
//  Created by Nikhil Sakhare on 18/11/17.
//  Copyright © 2017 Nikhil Sakhare. All rights reserved.
//

import UIKit

class DataProvider: NSObject {
    var apiClient: APIClient?
    static var sharedProvider: DataProvider = {
        let sharedProvider = DataProvider()
        return sharedProvider
    }()
    
    func startSyncEngine () {
        
        self.apiClient = APIClient { [unowned self] (requestType, arrayOfData) -> Void in
            guard let records = arrayOfData else {
                print("Error unwrapping records"); return }
            self.syncRecords(requestType, records)
        }
        
    }
    
    func triggerDataUpdate(entityType: Entities, completion: @escaping () -> Void) {
        
        APIClient.fetchList(requestType: entityType) { [unowned self] (requestType, arrayOfData) in
            guard let records = arrayOfData else {
                print("Error unwrapping records");
                completion()
                return
            }
            self.syncRecords(requestType, records)
            completion()
        }
    }
    
    func stopSyncEngine () {
        
        self.apiClient?.stopFetch()
        
    }
    
    func syncRecords(_ entityType: Entities, _ arrayRecords: Array<Any>) {
        switch entityType {
        case .City:
            CityWeather.saveUpdateCityWeatherData(records: arrayRecords)
        }
    }
}
