//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Nikhil Sakhare on 18/11/17.
//  Copyright © 2017 Nikhil Sakhare. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {

    static var sharedManager: CoreDataManager = {
        let sharedManager = CoreDataManager()
        return sharedManager
    }()
    
    
    lazy var applicationDatabaseDirectory: URL = {
    
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let url = urls.first?.appendingPathComponent("Database")
        
        do {
            try FileManager.default.createDirectory(atPath: (url?.path)!, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        return url!
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
   
        let modelURL = Bundle.main.url(forResource: "Weather", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
        
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
       
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        var url = self.applicationDatabaseDirectory.appendingPathComponent("Weather.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption:true, NSInferMappingModelAutomaticallyOption:true])
            
        } catch {
            
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
            
        }
        return coordinator
        
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
       
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        
    }()
    
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                
                try managedObjectContext.save()
                
            } catch {
                
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
                
            }
        }
    }
    
    func deleteContextObject(obj: NSManagedObject) {
        
        self.managedObjectContext.delete(obj)
        self.saveContext()
        
    }

}
