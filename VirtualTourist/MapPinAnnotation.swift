//
//  MapPinAnnotation.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//


import Foundation
import MapKit

public class MapPinAnnotation: NSObject, MKAnnotation {
    
    public var title:String?
    public var subtitle:String?
    public var coordinate: CLLocationCoordinate2D
    public var location:Pin?
    
    init(lattitude: Double, longitude:Double) {
        self.coordinate = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        super.init()
    }
}
