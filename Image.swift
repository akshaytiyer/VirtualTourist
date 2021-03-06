//
//  Image.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Image)

public class Image : NSManagedObject {
    
    @NSManaged public var image: NSData!
    @NSManaged public var flickrURL:String!
    @NSManaged public var pin: Pin?
    
    override public var description:String {
        get {
            return self.flickrURL!
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(location: Pin, imageURL: NSURL, context:NSManagedObjectContext) {
        let name = self.dynamicType.entityName()
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.flickrURL = imageURL.absoluteString
        //let imageStored = UIImage(data: NSData(contentsOfURL: imageURL)!)
        //self.image = UIImagePNGRepresentation(imageStored!)!
        self.pin = location
    }
}

public func ==(lhs:Image, rhs:Image) -> Bool {
    return lhs.flickrURL.isEqual(rhs)
}
