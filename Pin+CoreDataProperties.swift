//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 7/3/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var lattitude: NSDecimalNumber?
    @NSManaged var longitude: NSDecimalNumber?
    @NSManaged var creationDate: NSDate?
    @NSManaged var images: NSSet?

}
