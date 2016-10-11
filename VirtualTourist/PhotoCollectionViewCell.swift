 //
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 9/2/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell, ImageLoadDelegate {
    
    @IBOutlet weak var placeHolderView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    var image:Image!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureCellWithPhoto()
        self.placeHolderView.layer.cornerRadius = 3.0
        self.progressView.layer.cornerRadius = 3.0
    }
    
    func configureLoadingCell() {
        self.imageView.image = nil
        self.imageView.hidden = true
        self.placeHolderView.hidden = false
        self.progressView.progress = 0
        self.layoutIfNeeded()
    }
    
    func configureCellWithPhoto() {
        
        //self.imageView.image = UIImage(data: image.image)
        self.placeHolderView.hidden = false
        self.imageView.hidden = false
    }
    
    func progress(progress:CGFloat) {
        self.progressView.progress = Float(progress)
        self.layoutIfNeeded()
    }
    
    func didFinishLoad() {
        dispatch_async(dispatch_get_main_queue()) {
            self.configureCellWithPhoto()
        }
    }
}
