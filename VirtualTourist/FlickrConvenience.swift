//
//  FlickrConvenience.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation
import CoreData

private let MAX_PHOTOS = 39


extension FlickrClient {
    
    public func getPhototosFromFlickerSearch(annotation:Pin, delegate:FlickrDelegate?) {
        self.getImageFromFlickerSearch(annotation) { success, result, errorString in
            print("Flickr search done")
            if success {
                let photos = [Image]()
                var urls:[NSURL] = [NSURL]()
                for nextPhoto in result! {
                    if urls.count >= MAX_PHOTOS {
                        break
                    }
                    let imageUrlString = nextPhoto["url_m"] as? String
                    print(imageUrlString)
                    if let imageURL = NSURL(string: imageUrlString!) {
                        urls.append(imageURL)
                    }
                }
                
           /* self.sharedModelContext.performBlockAndWait {
                for url in urls {
                        let _ = Image(location: (self.sharedModelContext.objectWithID(annotation.objectID) as? Pin)!, imageURL: url, context: self.sharedModelContext)
                        //photo.pin = annotation
                        saveContext(self.sharedModelContext)
                        CoreDataStackManager.sharedInstance().saveContext()
                    }
                } */

                
                //print(annotation.objectID)
                //CoreDataStackManager.sharedInstance().saveContext()
                print(self.sharedModelContext.objectWithID(annotation.objectID))
                if let pinLocation = self.sharedModelContext.objectWithID(annotation.objectID) as? Pin {
                    _ = urls.map({ Image(location: pinLocation, imageURL: $0, context: self.sharedModelContext)})
                   NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FlickrClient.mergeChanges(_:)), name: NSManagedObjectContextDidSaveNotification, object: self.sharedModelContext)
                    saveContext(self.sharedModelContext) { success in
                        dispatch_async(dispatch_get_main_queue()) {
                                delegate?.didSearchLocationImages(true, location: annotation, photos: photos, errorString: nil)
                        }
                        }
                }
                
            } else {
                delegate?.didSearchLocationImages(false, location: annotation, photos: nil, errorString: errorString)
            }
        }
    }
    public func mergeChanges(notification:NSNotification) {
        let mainContext:NSManagedObjectContext = CoreDataStackManager.sharedInstance().dataStack.managedObjectContext
        dispatch_async(dispatch_get_main_queue()) {
            mainContext.mergeChangesFromContextDidSaveNotification(notification)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    public func getImageFromFlickerSearch(annotation:Pin, completionHandler:(success:Bool, result:[[String: AnyObject]]?, errorString:String?) -> Void) {
        let parameters = [
            FlickrClient.ParameterKeys.METHOD : FlickrClient.Methods.SEARCH,
            FlickrClient.ParameterKeys.API_KEY : FLICKR_API_KEY,
            FlickrClient.ParameterKeys.BBOX : self.createBoundingBoxString(annotation),
            FlickrClient.ParameterKeys.SAFE_SEARCH : FlickrClient.Constants.SAFE_SEARCH,
            FlickrClient.ParameterKeys.EXTRAS : FlickrClient.Constants.EXTRAS,
            FlickrClient.ParameterKeys.FORMAT : FlickrClient.Constants.DATA_FORMAT,
            FlickrClient.ParameterKeys.NO_JSON_CALLBACK : FlickrClient.Constants.NO_JSON_CALLBACK
        ]
        self.httpClient?.taskForGETMethod("", parameters: parameters) { JSONResult, error in
            if let _ = error {
                completionHandler(success: false, result: nil, errorString: "Can not find photos for location")
            } else  {
                if let photosDictionary = JSONResult.valueForKey("photos") as? [String:AnyObject] {
                    
                    if let totalPages = photosDictionary["pages"] as? Int {
                        
                        /* Flickr API - will only return up the 4000 images (100 per page * 40 page max) */
                        let pageLimit = min(totalPages, 40)
                        let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
                        self.getImageFromFlickrBySearchWithPage(parameters, pageNumber: randomPage, completionHandler: completionHandler)
                        
                    } else {
                        completionHandler(success:false, result:nil, errorString:"Cant find key 'pages' in result")
                    }
                } else {
                    completionHandler(success:false, result:nil, errorString:"Cant find key 'pages' in result")
                }
            }
        }
    }
    
    private func getImageFromFlickrBySearchWithPage(methodArguments: [String : AnyObject], pageNumber: Int, completionHandler:(success:Bool, result:[[String: AnyObject]]?, errorString:String?) -> Void) {
        var withPageDictionary = methodArguments
        withPageDictionary["page"] = pageNumber
        self.httpClient?.taskForGETMethod("", parameters: withPageDictionary) { JSONResult, error in
            if let _ = error {
                completionHandler(success: false, result: nil, errorString: "Can not find photos for location")
            } else {
                if let photosDictionary = JSONResult.valueForKey("photos") as? [String:AnyObject] {
                    var totalPhotosVal = 0
                    if let totalPhotos = photosDictionary["total"] as? String {
                        totalPhotosVal = (totalPhotos as NSString).integerValue
                    }
                    
                    if totalPhotosVal > 0 {
                        if let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] {
                            if photosArray.count > 0 {
                                print(photosArray.count)
                                completionHandler(success: true, result: photosArray, errorString: nil)
                            } else {
                                completionHandler(success: false, result: nil, errorString: "Images does not exist for this location")
                            }
                        } else {
                            completionHandler(success: false, result: nil, errorString: "Cant find key 'photo' in response")
                        }
                    } else {
                        completionHandler(success: false, result: nil, errorString: "No Photos Found")
                    }
                } else {
                    completionHandler(success: false, result: nil, errorString: "Cant find key 'photo' in response")
                }
            }
            
        }
    }
    
    private func createBoundingBoxString(annotation:Pin) -> String {
        
        let latitude = annotation.lattitude as Double
        let longitude = annotation.longitude as Double
        
        /* Fix added to ensure box is bounded by minimum and maximums */
        let bottom_left_lon = max(longitude - FlickrClient.Constants.BOUNDING_BOX_HALF_WIDTH, FlickrClient.Constants.LON_MIN)
        let bottom_left_lat = max(latitude - FlickrClient.Constants.BOUNDING_BOX_HALF_HEIGHT, FlickrClient.Constants.LAT_MIN)
        let top_right_lon = min(longitude + FlickrClient.Constants.BOUNDING_BOX_HALF_HEIGHT, FlickrClient.Constants.LON_MAX)
        let top_right_lat = min(latitude + FlickrClient.Constants.BOUNDING_BOX_HALF_HEIGHT, FlickrClient.Constants.LAT_MAX)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }
    
    func downloadImage(let imagePath:String, completionHandler: (imageData: NSData?, errorString: String?) -> Void){
        let session = NSURLSession.sharedSession()
        let imgURL = NSURL(string: imagePath)
        let request: NSURLRequest = NSURLRequest(URL: imgURL!)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if downloadError != nil {
                completionHandler(imageData: nil, errorString: "Could not download image \(imagePath)")
            } else {
                
                completionHandler(imageData: data, errorString: nil)
            }
        }
        
        task.resume()
    }
}
