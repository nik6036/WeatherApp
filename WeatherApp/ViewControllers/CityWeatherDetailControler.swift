//
//  CityWeatherDetailControler.swift
//  WeatherApp
//
//  Created by Nikhil Sakhare on 19/11/17.
//  Copyright © 2017 Nikhil Sakhare. All rights reserved.
//

import UIKit

class CityWeatherDetailControler: UIViewController {
    @objc var cityModel: CityWeather?
    @IBOutlet var cityId: UILabel!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var minTemperature: UILabel!
    @IBOutlet var maxTemperature: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = cityModel {
            self.setOutlets(model)
            addObserver(self, forKeyPath: #keyPath(cityModel.temperature), options: [.old, .new], context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(cityModel.temperature) {
            if (self.temperature.text != String(describing: cityModel?.temperature)) {
                self.setOutlets(cityModel!)
            }
        }
    }
    
    func setOutlets(_ model: CityWeather) {
        self.cityId.text = model.cityId
        self.cityName.text = model.cityName
        self.temperature.text = String(describing: model.temperature)
        self.humidity.text = String(describing: model.humidity)
        self.pressure.text = String(describing: model.pressure)
        self.minTemperature.text = String(describing: model.minTemperature)
        self.maxTemperature.text = String(describing: model.maxTemperature)
        Animations.animateLabelSeries([self.cityId, self.cityName, self.temperature, self.humidity, self.pressure, self.minTemperature, self.maxTemperature])
    }
}
