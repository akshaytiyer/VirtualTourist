//
//  CoreDataStackManager.swift
//  FavoriteActors
//
//  Created by Jason on 3/10/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import CoreData

/**
* The CoreDataStackManager contains the code that was previously living in the
* AppDelegate in Lesson 3. Apple puts the code in the AppDelegate in many of their
* Xcode templates. But they put it in a convenience class like this in sample code
* like the "Earthquakes" project.
*
*/

import Foundation
import CoreData

class CoreDataStackManager {
    
    class func sharedInstance() -> CoreDataStackManager {
        struct Static {
            static let instance = CoreDataStackManager()
        }
        return Static.instance
    }
    
    lazy var dataModel:CoreDataModel = {
        return CoreDataModel(name: "VirtualTourist")
    }()
    
    lazy var dataStack:CoreDataStack = {
        return CoreDataStack(model: self.dataModel)
    }()
    
    func saveContext() {
        var error:NSError? = nil
        if self.dataStack.managedObjectContext.hasChanges {
            do {
                try self.dataStack.managedObjectContext.save()
            } catch let error1 as NSError {
                error = error1
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
}
