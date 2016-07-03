//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 7/3/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate {

    //MARK: Properties
    var mapViewInEditState = false
    
    //MARK: Outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var deleteLabel: UILabel!
    @IBOutlet var mapViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: Edit Action
    @IBAction func editMapViewConstraints(sender: AnyObject) {
        animateMapViewConstraintChange()
    }
    
    let annotation = MKPointAnnotation()
    
    //MARK: Helper Method to change state of navigation bar
    func animateMapViewConstraintChange(){
        if (!mapViewInEditState) {
            // slide up
            mapViewInEditState = true
            navigationItem.rightBarButtonItem?.title = "Done"
            navigationItem.rightBarButtonItem?.style = .Done
            setNewMapViewConstraints()
            UIView.animateWithDuration(0.07) {
                self.view.layoutIfNeeded()
            }
            
        } else {
            // slide down
            mapViewInEditState = false
            navigationItem.rightBarButtonItem?.title = "Edit"
            navigationItem.rightBarButtonItem?.style = .Plain
            setMapViewConstraintsNormal()
            UIView.animateWithDuration(0.07) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.addAnnotation(_:)))
        longPress.minimumPressDuration = 2.0
        self.mapView.addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.removeAnnotation(_:)))
        tap.numberOfTapsRequired = 1
        self.mapView.addGestureRecognizer(tap)
    }
    
    //Set the new constraints for the map view
    func setNewMapViewConstraints() {
        self.mapViewBottomConstraint.constant += self.deleteLabel.frame.height
    }
    
    //Set the map view to the old constraints
    func setMapViewConstraintsNormal() {
        self.mapViewBottomConstraint.constant -= self.deleteLabel.frame.height
    }
    
    func removeAnnotation(gesture: UIGestureRecognizer) {
        
        if (mapViewInEditState) {
            if gesture.state == UIGestureRecognizerState.Ended {
                self.mapView.removeAnnotation(annotation)
                print("Annotation Removed")
            }
        }
        
    }
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            annotation.coordinate = newCoordinates
            self.mapView.addAnnotation(annotation)
        }
    }
}

