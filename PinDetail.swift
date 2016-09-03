//
//  PinDetail.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(PinDetail)

public class PinDetail: NSManagedObject {
    
    @NSManaged var locality:String
    @NSManaged var location:Pin
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(location:Pin, locality:String, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.locality = locality
        self.location = location
    }
}
