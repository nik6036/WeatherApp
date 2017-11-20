//
//  Analitics+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Nikhil Sakhare on 18/11/17.
//  Copyright © 2017 Nikhil Sakhare. All rights reserved.
//

import Foundation
import CoreData

private let EntityName = "CityWeather"
extension CityWeather {
    static var models: [CityWeather]? {
         set {}
         get { return fetchWeatherRecords() }
    }
    
    @NSManaged public var cityId: String
    @NSManaged public var cityName: String
    @NSManaged public var temperature: Double
    @NSManaged public var humidity: Int64
    @NSManaged public var pressure: Int64
    @NSManaged public var minTemperature: Double
    @NSManaged public var maxTemperature: Double
   
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityWeather> {
        return NSFetchRequest<CityWeather>(entityName: EntityName)
    }
    
    class func saveUpdateCityWeatherData(records: Array<Any>) -> Void {
        
        for record in records {
            let values = record as! Dictionary<String,Any>
            var cityWeather = CityWeather.fetchCityWeatherForId(cityId: (String(describing: values["id"]!)))
            if cityWeather == nil {
                let entityDescription = NSEntityDescription.entity(forEntityName: EntityName, in: CoreDataManager.sharedManager.managedObjectContext)
                cityWeather = NSManagedObject(entity: entityDescription!, insertInto: CoreDataManager.sharedManager.managedObjectContext) as? CityWeather
            }
            cityWeather?.cityId = String(describing: values["id"]!)
            cityWeather?.cityName = String(describing: values["name"]!)
            var nestedContainer = values["main"]! as! Dictionary<String,Any>
            cityWeather?.temperature = nestedContainer["temp"] as! Double
            cityWeather?.humidity = Int64(nestedContainer["humidity"] as! Int)
            cityWeather?.pressure = Int64(nestedContainer["pressure"] as! Int)
            cityWeather?.minTemperature = nestedContainer["temp_min"] as! Double
            cityWeather?.maxTemperature = nestedContainer["temp_max"]as! Double
            CityWeather.models?.append(cityWeather!)
        }
        CoreDataManager.sharedManager.saveContext()
    }
    
    class func fetchCityWeatherForId(cityId: String) -> CityWeather? {
        
        var cityRecord: CityWeather? = nil
        let model = CityWeather.models?.filter{ $0.cityId == cityId }.first
        if let existingModel = model {
            cityRecord = existingModel
            CityWeather.models = CityWeather.models?.filter{ $0.cityId != cityId }
        } else {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            let entityDescription = NSEntityDescription.entity(forEntityName: EntityName, in: CoreDataManager.sharedManager.managedObjectContext)
            fetchRequest.entity = entityDescription
            let predicate = NSPredicate(format: "cityId == '\(cityId)'")
            fetchRequest.predicate = predicate
            do {
                let result = try CoreDataManager.sharedManager.managedObjectContext.fetch(fetchRequest)
                cityRecord = (result.count > 0 ? result.first as? CityWeather : nil)
            } catch {
                let fetchError = error as NSError
                print(fetchError)
            }
        }
        return cityRecord
    }
    
    class func fetchWeatherRecords() -> [CityWeather]? {
        var result : Array<CityWeather>?
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            let entityDescription = NSEntityDescription.entity(forEntityName: EntityName, in: CoreDataManager.sharedManager.managedObjectContext)
            fetchRequest.entity = entityDescription
            do {
                result = try CoreDataManager.sharedManager.managedObjectContext.fetch(fetchRequest) as? Array<CityWeather>
                
            } catch {
                let fetchError = error as NSError
                print(fetchError)
            }
        return result
    }
}
