//
//  FlickrDelegate.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation

public protocol FlickrDelegate {
    
    func didSearchLocationImages(success:Bool, location:Pin, photos:[Image]?, errorString:String?)
}
