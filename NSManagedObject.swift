//
//  NSManagedObject.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    class func entityName() -> String {
        let fullClassName = NSStringFromClass(object_getClass(self))
        let nameComponents = fullClassName.characters.split{ $0 == "."}.map { String($0) }
        return nameComponents.last!
    }
    
    convenience init(context:NSManagedObjectContext) {
        let name = self.dynamicType.entityName()
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}