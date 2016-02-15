//
//  MapViewController.swift
//  Yelp
//
//  Created by WUSTL STS on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
//        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        for business in businesses {
            let centerLocation = business.coordinates
            goToLocation(centerLocation!, name: business.name!)
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocation, name: String) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
        addAnnotationAtCoordinate(location.coordinate, name: name)

    }
    
    @IBAction func onDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: CLLocationManagerDelegate {
    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////        print(locations)
//        if let location = locations.first {
//            print(location)
//            let span = MKCoordinateSpanMake(0.1, 0.1)
//            let region = MKCoordinateRegionMake(location.coordinate, span)
//            mapView.setRegion(region, animated: false)
//            addAnnotationAtCoordinate(location.coordinate)
//        }
//    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, name: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)
    }


}
