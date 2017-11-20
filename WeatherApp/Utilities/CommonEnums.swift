//
//  CommonEnums.swift
//  WeatherApp
//
//  Created by Nikhil Sakhare on 18/11/17.
//  Copyright © 2017 Nikhil Sakhare. All rights reserved.
//

import Foundation

public enum Entities {

    case City
   
}

public enum APIProviders {
    
    case OpenWeatherMap
    
    var rawValue: String {
        switch self {
        case .OpenWeatherMap: return "http://api.openweathermap.org/data/2.5/group?id="
        }
    }
}

public enum APIKeys {
    
    case OpenWeatherMap
    
    var rawValue: String {
        switch self {
        case .OpenWeatherMap: return "a5e93611099aee73ac2d80998203b92c"
        }
    }
}
