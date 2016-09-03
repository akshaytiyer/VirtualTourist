//
//  ImageLoadDelegate.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation
import QuartzCore

protocol ImageLoadDelegate {
    
    func progress(progress:CGFloat)
    
    func didFinishLoad()
}
