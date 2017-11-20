//
//  UrlBuilder.swift
//  WeatherApp
//
//  Created by Nikhil Sakhare on 18/11/17.
//  Copyright © 2017 Nikhil Sakhare. All rights reserved.
//

import UIKit

class URLBuilder: NSObject {

    func getURL(entity: Entities) -> String {
        switch entity {
        case .City:
            return getUrlForRegisterdCities()
        }
    }
    
    func getUrlForRegisterdCities() -> String {
        var urlString: String = APIProviders.OpenWeatherMap.rawValue
        let values = Array(AppDelegate.registeredCities.values)
        urlString += values.joined(separator: ",")
        urlString += "&units=metric"
        urlString += "&APPID=\(APIKeys.OpenWeatherMap.rawValue)"
        return urlString
    }
}
