//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation
import CoreData

let FLICKR_API_KEY = "8c97222cbce046fd94f0c1a6fc17a022"

public class FlickrClient: NSObject, FlickrHTTPClientProtocol {
    
    var httpClient:FlickrHTTPClient?
    
    override init() {
        super.init()
        self.httpClient = FlickrHTTPClient(delegate: self)
    }
    
    public func getBaseURLSecure() -> String {
        return FlickrClient.Constants.BASE_URL
    }
    
    public func addRequestHeaders(request: NSMutableURLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    public func processJsonBody(jsonBody: [String : AnyObject]) -> [String : AnyObject] {
        return jsonBody
    }
    
    public func processResponse(data: NSData) -> NSData {
        return data
    }
    
    lazy var sharedModelContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().dataStack.childManagedObjectContext(NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
//        let coordinator = CoreDataStackManager.sharedInstance().dataStack.persistentStoreCoordinator
//        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        //managedObjectContext.parentContext = CoreDataStackManager.sharedInstance().dataStack.managedObjectContext
//        managedObjectContext.mergePolicy = NSMergePolicy(mergeType: NSMergePolicyType.MergeByPropertyObjectTrumpMergePolicyType);
//        return managedObjectContext
    }()
    
    // MARK: - Shared Instance
    
    public class func sharedInstance() -> FlickrClient {
        
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        
        return Singleton.sharedInstance
    }
}
