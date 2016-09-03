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
    
    @NSManaged public var image:String
    @NSManaged public var flickrURL:NSURL
    @NSManaged public var pin: Pin?
    
    override public var description:String {
        get {
            return self.flickrURL.path!
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(location: Pin, imageURL:NSURL, context:NSManagedObjectContext) {
        let name = self.dynamicType.entityName()
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.flickrURL = imageURL
        self.image = self.flickrURL.lastPathComponent!
        self.pin = location
        if self.internalimage == nil {
            _ = PhotoDownloadWorker(image: self)
        }
    }
    
    public override func prepareForDeletion() {
        self.internalimage = nil
    }
    
    var internalimage:UIImage? {
        get {
            return ImageCache.sharedInstance().imageWithIdentifier("\(self.image)")
        }
        
        set {
            ImageCache.sharedInstance().storeImage(newValue, withIdentifier: "\(self.image)")
        }
    }
}

public func ==(lhs:Image, rhs:Image) -> Bool {
    return lhs.flickrURL.isEqual(rhs)
}