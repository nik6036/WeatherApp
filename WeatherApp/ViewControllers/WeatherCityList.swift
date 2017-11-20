//
//  WeatherCityList.swift
//  WeatherApp
//
//  Created by Nikhil Sakhare on 18/11/17.
//  Copyright © 2017 Nikhil Sakhare. All rights reserved.
//

import UIKit

class WeatherCityList: UITableViewController {
    
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    var viewModel: WeatherViewModel = WeatherViewModel()
    var cityModels: Array<CityWeather>?
    var selectedDetailModel: CityWeather?
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        self.activityLoader.startAnimating()
        viewModel.getCities { [unowned self] in
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {[unowned self] in
                    self.activityLoader.stopAnimating()
                }
            }
        }
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfCitiesToDisplay(in: section)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CityWeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CityWeatherCell", for: indexPath) as! CityWeatherTableViewCell
        let model = viewModel.cityToDisplay(for: indexPath)
        if let currentModel = model {
            cell.cityName.text = currentModel.cityName
            cell.cityTemperature.text = String(describing: currentModel.temperature)
            cell.model = currentModel
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let model = viewModel.cityToDisplay(for: indexPath)
        self.selectedDetailModel = model
        performSegue(withIdentifier: "CityWeatherDetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CityWeatherDetail" {
            if let detail = segue.destination as? CityWeatherDetailControler {
                if let model = self.selectedDetailModel {
                    detail.cityModel = model
                }
            }
        }
    }
}




















