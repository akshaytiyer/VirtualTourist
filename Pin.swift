//
//  Pin.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation
import CoreData

@objc(Pin)

public class Pin : NSManagedObject {
    
    @NSManaged public var lattitude:NSNumber
    @NSManaged public var longitude:NSNumber
    @NSManaged public var images:[Image]
    @NSManaged public var details:PinDetail?
    
    override public var description:String {
        get {
            return "latitude:\(self.lattitude)::longitude:\(self.longitude)"
        }
    }
    
    override public var hashValue : Int {
        get {
            return self.description.hashValue
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(lattitude:NSNumber, longitude:NSNumber, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.lattitude = lattitude
        self.longitude = longitude
    }
    
    func isDownloading() -> Bool {
        var result = false
        print(self.images.count)
        for next in self.images {
            if let downloadWorker = PendingPhotoDownloads.sharedInstance().downloadsInProgress[next.description.hashValue] as? PhotoDownloadWorker {
                if downloadWorker.isDownloading() {
                    result = true
                    break
                }
            }
        }
        
        return result
    }
}

public func ==(lhs:Pin, rhs: Pin) -> Bool {
    return lhs.lattitude.isEqualToNumber(rhs.lattitude) && lhs.longitude.isEqualToNumber(rhs.longitude)
}