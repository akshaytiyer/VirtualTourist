//
//  FlickrPhotoDelegate.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation

public class FlickrPhotoDelegate: FlickrDelegate {
    
    class func sharedInstance() -> FlickrPhotoDelegate {
        struct Static {
            static let instance = FlickrPhotoDelegate()
        }
        return Static.instance
    }
    
    var onLoad:Set<Pin> = Set()
    var delegates:[Pin:FlickrDelegate] = [Pin:FlickrDelegate]()
    
    public func didSearchLocationImages(success:Bool, location:Pin, photos:[Image]?, errorString:String?) {
        self.onLoad.remove(location)
        if let delegate = delegates[location] {
            delegate.didSearchLocationImages(success, location: location, photos: photos, errorString: errorString)
        }
        self.delegates.removeValueForKey(location)
    }
    
    public func searchPhotos(location:Pin) {
        self.onLoad.insert(location)
        FlickrClient.sharedInstance().getPhototosFromFlickerSearch(location, delegate: self)
    }
    
    public func isLoading(location:Pin) -> Bool {
        return self.onLoad.contains(location)
    }
    
    public func addDelegate(location:Pin, delegate:FlickrDelegate) {
        delegates[location] = delegate
    }
}