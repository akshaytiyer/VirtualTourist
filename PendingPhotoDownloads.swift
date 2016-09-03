//
//  PendingPhotoDownloads.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation

class PendingPhotoDownloads: NSObject {
    
    class func sharedInstance() -> PendingPhotoDownloads {
        struct Static {
            static let instance = PendingPhotoDownloads()
        }
        return Static.instance
    }
    
    var downloadsInProgress:[Int:AnyObject] = [Int:AnyObject]()
    var downloadQueue:NSOperationQueue
    var downloadWorkers:Set<PhotoDownloadWorker> = Set()
    
    override init() {
        downloadQueue = NSOperationQueue()
        downloadQueue.name = "Download Queue"
        downloadQueue.maxConcurrentOperationCount = 6
        super.init()
    }
    
    
}