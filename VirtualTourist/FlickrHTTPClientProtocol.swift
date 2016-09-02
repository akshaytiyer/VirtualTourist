//
//  FlickrHTTPClientProtocol.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation

public protocol FlickrHTTPClientProtocol {
    
    func getBaseURLSecure() -> String
    func addRequestHeaders(request:NSMutableURLRequest)
    func processJsonBody(jsonBody:[String:AnyObject]) -> [String:AnyObject]
    func processResponse(data:NSData) -> NSData
}
