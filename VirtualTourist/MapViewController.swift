//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Akshay Iyer on 7/3/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

    //MARK: Properties
    var mapViewInEditState = false
    var annotations = [MKPointAnnotation]()
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    //MARK: Outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var deleteLabel: UILabel!
    @IBOutlet var mapViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: Edit Action
    @IBAction func editMapViewConstraints(sender: AnyObject) {
        animateMapViewConstraintChange()
    }
    
    
    
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
        longPress.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPress)
        self.mapView.delegate = self
    }

    //Set the new constraints for the map view
    func setNewMapViewConstraints() {
        self.mapViewBottomConstraint.constant += self.deleteLabel.frame.height
    }
    
    //Set the map view to the old constraints
    func setMapViewConstraintsNormal() {
        self.mapViewBottomConstraint.constant -= self.deleteLabel.frame.height
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let selected = view.annotation as! MKPointAnnotation
        self.annotations.append(selected)
        if (mapViewInEditState) {
            self.mapView.removeAnnotation(selected)
            print("Annotation Removed")
        }
    }
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let annotation = MKPointAnnotation()
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let lastPin = Pin(latitude: NSDecimalNumber(double: newCoordinates.latitude), longitude: NSDecimalNumber(double: newCoordinates.longitude), insertIntoManagedObjectContext: sharedContext)
            print("Successfully saved data \(lastPin)")
            annotation.coordinate = newCoordinates
            self.mapView.addAnnotation(annotation)
        }
    }
}

